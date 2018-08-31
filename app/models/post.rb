class Post < ApplicationRecord
	acts_as_paranoid
	acts_as_votable

	mount_uploader :image, ImageUploader

	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings
	belongs_to :user, counter_cache: true
  has_many :comments, dependent: :destroy
  has_one :last_comment, -> { created_at_desc }, class_name: 'Comment'

	validates :title, :content, presence: true

  # default_scope { order("created_at ASC") }

  scope :order_by, ->(category, direction) {
    case category
    when 'created_at'
      order("posts.created_at #{direction}")
    when 'username'
      joins(:user).merge(User.order("username #{direction}"))
    when 'votes'
      order("cached_votes_total #{direction}")
    when 'lenght'
      order("LENGTH(content) #{direction}")
    when 'author_votes'
      joins("(SELECT user_id, sum(cached_votes_total) AS author_votes
            FROM posts
            GROUP BY user_id) AS total ON posts.user_id = total.user_id")
      .order("author_votes #{direction}")
        # find_by_sql("
        #   SELECT *
        #   FROM posts
        #   JOIN (SELECT user_id, sum(cached_votes_total) AS author_votes
        #         FROM posts
        #         GROUP BY user_id) AS total ON posts.user_id = total.user_id
        #   ORDER BY author_votes #{direction}")
    when 'comment_counts'
      group("posts.id").left_joins(:comments).select('posts.*, comments.count AS count')
      .order("count #{direction} NULLS LAST")
    when 'comment_last'
      group("posts.id").left_joins(:comments).order("MAX(comments.created_at) #{direction} NULLS LAST")
    end
   }

	def user
	  User.unscoped { super }
	end

  def self.filter(params_filter)
    return @posts = Post.all.order_by(category(params_filter), direction(params_filter)) unless params_filter.present?
    @posts = Post.all
    @posts = @posts.where('title ILIKE ? OR content ILIKE ?', "%#{params_filter[:keyword]}%", "%#{params_filter[:keyword]}%") if params_filter[:keyword].present?
    @posts = @posts.joins(:user).where(users: { username: params_filter[:author]}) if params_filter[:author].present?
    @posts = @posts.joins(:tags).where( tags:{ id: params_filter[:tag_ids]} ).having('count(tags.id) = ?', params_filter[:tag_ids].count).group("posts.id") if params_filter[:tag_ids].present?
    @posts = @posts.order_by(params_filter[:category], params_filter[:direction])
    @posts
  end

	def all_tags
		self.tags.map(&:name).join(', ')
	end

	def all_tags=(names)
    self.tags = names.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def self.category(params_filter)
    params_filter && params_filter[:category].present? ? params_filter[:category] : 'created_at'
  end

  def self.direction(params_filter)
    params_filter && params_filter[:direction].present? ? params_filter[:direction] : "DESC"
  end
end
