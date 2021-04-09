class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :image_count
      t.integer :primary_image_id

      t.timestamps
    end
  end
end
