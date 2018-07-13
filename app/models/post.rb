class Post < ApplicationRecord
	acts_as_paranoid
	acts_as_votable

	mount_uploader :image, ImageUploader

	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings
	belongs_to :user

	validates :title, :content, presence: true

  scope :order_posts, ->(category, direction) {
    case category
    when 'created_at'
      order("created_at #{direction}")
    when 'username'
      joins(:user).merge(User.order("username #{direction}"))
    when 'votes'
      order("cached_votes_total #{direction}")
    end
   }

	def user
	  User.unscoped { super }
	end

  def self.filter(params_filter)
    #binding.pry
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
