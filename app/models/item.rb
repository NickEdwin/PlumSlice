class Item < ApplicationRecord
  validates_presence_of :name

  has_many :images

  def set_image_counts
		items = Item.all

    items.each do |item|
      item.image_count = Image.where("item_id = ?", item.id).count
      item.save
    end
	end

  def set_primary_image_ids
    items = Item.all
    name = "_m"

    items.each do |item|
      image = Image.where("item_id = ? AND file_name LIKE ?", item.id, "%#{name}%").first
      item.primary_image_id = image.id
      item.save
    end
	end

  def self.image_hash(item_id)
    item = Item.find(item_id)
    name = "_m"
    json = {"data": {
                    "id": item.id,
                    "type": "item",
                    "attributes":{
                      "item_name": item.name,
                      "image_count": item.image_count,
                      "primary_image_id": item.primary_image_id,
                      "primary_image_filename": Image.where("item_id = ? AND file_name LIKE ?", item.id, "%#{name}%").first.file_name
                }}}
  end
end
