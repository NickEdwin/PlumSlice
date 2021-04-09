require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "relationships" do
    it {should have_many :images}
  end

  describe "instance methods" do
    before(:each) do
      @item1 = Item.create(name: "Dog House", image_count: nil, primary_image_id: nil)
      @item2 = Item.create(name: "Cat Blanket", image_count: nil, primary_image_id: nil)
      @item3 = Item.create(name: "Frog Onesie", image_count: nil, primary_image_id: nil)

      @image1 = @item1.images.create(file_name: "dh_1_m.jpg")
      @image2 = @item1.images.create(file_name: "dh_2.jpg")
      @image3 = @item2.images.create(file_name: "cb_1_m.jpg")
      @image4 = @item2.images.create(file_name: "cb_2_m.jpg")
      @image5 = @item2.images.create(file_name: "cb_3_m.jpg")
      @image6 = @item3.images.create(file_name: "fo_1_m.jpg")
    end

    describe "can assign image counts to items" do
      it ".set_image_counts do" do
        expect(@item1.image_count).to eq(nil)

        @item1.set_image_counts

        @item1 = Item.first
        expect(@item1.image_count).to eq(2)
      end
    end

    describe "can assign first image title with '_m' in the name" do
      it ".set_primary_image_ids do" do
        expect(@item1.primary_image_id).to eq(nil)

        @item1.set_primary_image_ids

        @item1 = Item.first
        expect(@item1.primary_image_id).to eq(@image1.id)
      end
    end

    describe "it can return a JSON response" do
      it ".image_hash(item_id)" do
        response = {"data":{
                        "id": @item1.id,
                        "type": "item",
                        "attributes":{
                          "item_name": "Dog House",
                          "image_count": nil,
                          "primary_image_id": nil,
                          "primary_image_filename": "dh_1_m.jpg"
                    }}}

        expect(Item.image_hash(@item1.id)).to eq(response)
      end
    end
  end
end
