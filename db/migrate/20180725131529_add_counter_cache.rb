class AddCounterCache < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :posts_count, :integer
  end
end
