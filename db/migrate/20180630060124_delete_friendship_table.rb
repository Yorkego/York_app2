class DeleteFriendshipTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :friendships
  end
end
