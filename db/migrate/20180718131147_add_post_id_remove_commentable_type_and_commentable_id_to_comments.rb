class AddPostIdRemoveCommentableTypeAndCommentableIdToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :post_id, :integer
    remove_column :comments, :commentable_type
    remove_column :comments, :commentable_id
  end
end
