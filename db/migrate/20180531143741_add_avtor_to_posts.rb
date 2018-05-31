class AddAvtorToPosts < ActiveRecord::Migration[5.2]
  def change
  	def change
    create_table :posts do |t|
      t.text :title
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
  end
end
