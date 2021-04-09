# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Item.destroy_all
Image.destroy_all

item1 = Item.create(name: "Dog House", image_count: nil, primary_image_id: nil)
item2 = Item.create(name: "Cat Blanket", image_count: nil, primary_image_id: nil)
item3 = Item.create(name: "Frog Onesie", image_count: nil, primary_image_id: nil)

image1 = item1.images.create(file_name: "dh_1_m.jpg")
image2 = item1.images.create(file_name: "dh_2.jpg")
image3 = item2.images.create(file_name: "cb_1_m.jpg")
image4 = item2.images.create(file_name: "cb_2_m.jpg")
image5 = item2.images.create(file_name: "cb_3_m.jpg")
image6 = item3.images.create(file_name: "fo_1_m.jpg")
