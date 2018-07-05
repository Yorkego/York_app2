class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user_id, uniqueness: { scope: :friend_id, message: "already get your request" }
  validate :users_are_not_already_friends


  private

  def users_are_not_already_friends
    combinations = ["user_id = #{user_id} AND friend_id = #{friend_id} AND accepted = true",
    "user_id = #{friend_id} AND friend_id = #{user_id} AND accepted = true"]
    if Friendship.where(combinations.join(' OR ')).exists?
      self.errors.add(:user_id, 'Already friends!')
    end
  end

end
