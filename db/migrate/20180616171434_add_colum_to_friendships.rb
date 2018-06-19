class AddColumToFriendships < ActiveRecord::Migration[5.2]
  def change
  	add_column :friendships, :friendable_id, :integer
  	add_column :friendships, :friend_id, :integer
  	add_column :friendships, :blocker_id, :integer
  	add_column :friendships, :pending, :boolean, :default => true
  end
end
