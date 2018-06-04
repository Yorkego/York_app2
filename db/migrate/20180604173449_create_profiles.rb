class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :image, default: "default_image.jpg"

      t.timestamps
    end
  end
end
