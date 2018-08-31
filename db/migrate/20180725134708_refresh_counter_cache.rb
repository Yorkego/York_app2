class RefreshCounterCache < ActiveRecord::Migration[5.2]
  def change
    Post.find_each { |post| Post.reset_counters(post.id, :comments) }
    User.find_each { |user| User.reset_counters(user.id, :posts) }
    Post.find_each(&:update_cached_votes)

  end
end
