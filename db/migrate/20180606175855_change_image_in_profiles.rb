class ChangeImageInProfiles < ActiveRecord::Migration[5.2]
  def change
  	  drop_table :profiles

      create_table :profiles do |t|
         t.string :image, default: "default_image.jpg"
         

         t.timestamps
      end  	
  end
end
