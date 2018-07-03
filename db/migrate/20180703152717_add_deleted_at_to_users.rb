class AddDeletedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
    add_column :posts, :deleted_at, :datetime
    add_index :posts, :deleted_at
  end
end
