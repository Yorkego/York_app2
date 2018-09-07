class User < ApplicationRecord
  acts_as_paranoid
  acts_as_voter

  has_many :friendships
  has_many :received_friendships, class_name: "Friendship", foreign_key: "friend_id"

  has_many :active_friends, -> { where(friendships: { accepted: true}) }, through: :friendships, source: :friend
  has_many :received_friends, -> { where(friendships: { accepted: true}) }, through: :received_friendships, source: :user
  has_many :pending_friends, -> { where(friendships: { accepted: false}) }, through: :friendships, source: :friend
  has_many :requested_friendships, -> { where(friendships: { accepted: false}) }, through: :received_friendships, source: :user

	has_many :posts
  has_many :comments

  has_one :most_liked_post, -> { order("cached_votes_total desc") }, class_name: "Post"
  has_one :most_comentable_post, -> { group("posts.id").left_outer_joins(:comments)
                                      .order("comments.count desc") }, class_name: "Post"
  # has_one :sum_of_likes, -> { joins(select('user_id, sum(cached_votes_total) AS votes').group('user_id')) }, class_name: "Post"


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # default_scope { order("created_at ASC") }

  scope :authors, -> { where('EXISTS(SELECT 1 FROM posts WHERE user_id = users.id)') }
  scope :with_summ_of_likes, -> { left_outer_joins(:posts).select('users.*,
                              sum(posts.cached_votes_total) AS sum_votes').group('users.id') }

  scope :order_authors, ->(category, direction) {
    case category
    when 'created_at'
      order("created_at #{direction}")
    when 'username'
      order("username #{direction}")
    when 'votes'
      left_outer_joins(:posts).order("MAX(posts.cached_votes_total) #{direction}")
    when 'author_votes'
      left_outer_joins(:posts).order("sum_votes #{direction}")
    when 'comment_counts'
      left_outer_joins(:posts).order(Arel.sql("COUNT(posts.comments_count) #{direction}"))
    when 'comment_last'
      left_outer_joins(:comments).order(Arel.sql("MAX(comments.created_at) #{direction} NULLS LAST"))
    end
   }

  def self.filter(params_filter)
    return @authors = User.all.authors.order_authors(category(params_filter), direction(params_filter)) unless params_filter.present?
    @authors = User.all.authors
    @authors = @authors.where('username ILIKE ?', "%#{params_filter[:username]}%") if params_filter[:username].present?
    # byebug
    @authors = @authors.order_authors(category(params_filter), direction(params_filter))
    @authors
  end


 # to call all your friends
  def friends
    active_friends | received_friends
  end

# to call your pending sent or received
  def pending
    pending_friends | requested_friendships
  end

  def self.category(params_filter)
    params_filter && params_filter[:category].present? ? params_filter[:category] : 'created_at'
  end

  def self.direction(params_filter)
    params_filter && params_filter[:direction].present? ? params_filter[:direction] : "ASC"
  end


end
