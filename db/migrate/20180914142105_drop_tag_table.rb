class DropTagTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :tags, force: :cascade
    drop_table :taggings, force: :cascade
  end
end
