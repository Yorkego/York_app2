class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user_id, uniqueness: { scope: :friend_id, message: "you already send him request" }
  validate :users_are_not_already_friends
  validate :not_self

  private

  def not_self
    errors.add(:friend, "can't befriend yourself") if user == friend
  end

  def users_are_not_already_friends
    combinations = ["user_id = #{user_id} AND friend_id = #{friend_id}",
    "user_id = #{friend_id} AND friend_id = #{user_id}"]
    if Friendship.where(combinations.join(' OR ')).exists?
      self.errors.add(:user_id, 'Already friends!')
    end
  end

end
