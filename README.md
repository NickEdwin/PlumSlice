# PlumSliceLabs Challenge

## Table of Contents

- [Introduction](#introduction)
- [Background Information](#background-information)
- [Visual Schema](#visual-schema)
- [Questions with Answers](#questions-with-answers)
- [Sample JSON Response](#sample-json-response)

<!-- Brief Description -->

## Introduction
So intially I was trying to work out these queries in the provided doc.  
But me trying to do SQL queries in my head looks something like this:  
![SQL](https://media3.giphy.com/media/DHqth0hVQoIzS/giphy.gif)  
Therefore I decided the best way to ensure accuracy was to spin up a blank rails app, seed the DB and work them out in real time.  
**Side note**  
I wasn't originally planning on uploading this, it was just for me to use for testing and playing around.  
That being said there is *Zero* Git workflow to be seen and for that, I apologize.  

## Background Information  
This is application is built with Ruby 2.5.3 and Rails 6.0.3.4.  
PostgreSQL 12.3 used for database.  
RSpec was used for testing. [Testing File Here](https://github.com/NickEdwin/PlumSlice/blob/main/spec/models/item_spec.rb)  
Postico used for DB visualization as well as writing SQL queries.   

## Visual Schema
Simple database with a one to many relationship for Items and Images.
![Schema](https://i.imgur.com/QrvXoEh.png)  

## Questions with Answers
1.) Write a query(SQL or ActiveRecord) that returns all of the images associated with a given item.  
AR:  
```ruby
Image.where("item_id = ?", item.id)
```
SQL:  
```SQL
SELECT * FROM images
WHERE item_id = item.id;
```
2.) Write a method that would set the image_count for each item in the ITEMS table to the number of images associated with that item.  
AR:  
```ruby
def set_image_counts
  items = Item.all

  items.each do |item|
    item.image_count = Image.where("item_id = ?", item.id).count
    item.save
  end 
end
```
SQL injections in method:  
```SQL
def set_image_counts
  items = SELECT * FROM items;

  items.each do |item|
    item.image_count = SELECT COUNT(item_id)
                       FROM images 
                       WHERE item_id = item.id;
    item.save
  end 
end
```
3.) Write a method that sets the primary_image_id of each item to the id of the FIRST associated image with text tag '_m' in the file_name --> assume the number in the file_name is the order in which the images go, so image_1 would be the first image, etc.  
AR:  
```ruby
def set_primary_image_ids
    items = Item.all
    name = "_m"

    items.each do |item|
      image = Image.where("item_id = ? AND file_name LIKE ?", item.id, "%#{name}%").first
      item.primary_image_id = image.id
      item.save
    end
end
```
SQL injections in method:  
```SQL
def set_primary_image_ids
    items = SELECT * FROM items;
    items.each do |item|
      image = SELECT * 
              FROM images
              WHERE item_id = item.id AND file_name LIKE '%_m%' LIMIT(1);
      item.primary_image_id = image.id
      item.save
    end
end
```
4.) The following code is throwing an error. Can you find the problem and fix it without changing the overall structure of the method?
```ruby
def get_first_image_name(item)
  image = Image.where(item_id: item.id).first
  image.file_name
end
```
By adding ```.first``` we retrieve the first image found and not an array of images with that item id.

### Bonus  
Write a method that takes an item id as a parameter and returns a JSON hash with the following:  
- item_name  
- primary_image_id:  
- primary_image_filename:  
- image_count:  
```ruby
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
```

## Sample JSON response
A sample JSON response for bonus question.  (click to enlarge!)
![JSON](https://i.imgur.com/1YeX539.png)
I'm personally not the biggest fan of this solution as you can see in the model. It just feels... wrong.  
I like to implement the FastJSON gem, create a serializer that looks something like:  
```ruby
class ItemSerializer
  include FastJsonapi::ObjectSerializer
  
  attributes :id, :item_name, :primary_image_id, :image_count
end
```  
And then put a line like this in the controller:
```ruby
render json: ItemSerializer.new(item), status: 200
```
But I guess it technically solved the question!  

