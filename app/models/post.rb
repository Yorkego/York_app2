class Post < ApplicationRecord
	acts_as_paranoid
	acts_as_votable

	mount_uploader :image, ImageUploader

	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings
	belongs_to :user
  has_many :comments, dependent: :destroy

	validates :title, :content, presence: true

  scope :order_posts, ->(category, direction) {
    case category
    when 'created_at'
      order("created_at #{direction}")
    when 'username'
      joins(:user).merge(User.order("username #{direction}"))
    when 'votes'
      order("cached_votes_total #{direction}")
    when 'lenght'
      order("LENGTH(content) #{direction}")
    when 'author_votes'
      joins(:user).select('*, sum(user.posts.cached_votes_total) AS author_votes')
      .order("author_votes #{direction}")
        # find_by_sql("
        #   SELECT *
        #   FROM posts
        #   JOIN (SELECT user_id, sum(cached_votes_total) AS author_votes
        #         FROM posts
        #         GROUP BY user_id) AS total ON posts.user_id = total.user_id
        #   ORDER BY author_votes #{direction}")
    when 'comment_counts'
      group("posts.id").joins(:comments).select('posts.*, comments.count AS count')
      .merge(Comment.order("count #{direction}"))
    when 'comment_last'
      group("posts.id").joins(:comments).select('posts.*, MAX(comments.created_at) AS last_comment')
      .merge(Comment.order("last_comment #{direction}"))
    end
   }

	def user
	  User.unscoped { super }
	end

  def self.filter(params_filter)
    return @posts = Post.all unless params_filter.present?
    @posts = Post.all
    @posts = @posts.where('title ILIKE ? OR content ILIKE ?', "%#{params_filter[:keyword]}%", "%#{params_filter[:keyword]}%") if params_filter[:keyword].present?
    @posts = @posts.joins(:user).where(users: { username: params_filter[:author]}) if params_filter[:author].present?
    @posts = @posts.joins(:tags).where( tags:{ id: params_filter[:tag_ids]} ).having('count(tags.id) = ?', params_filter[:tag_ids].count).group("posts.id") if params_filter[:tag_ids].present?
    @posts = @posts.order_posts(params_filter[:category], params_filter[:direction])
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
end
