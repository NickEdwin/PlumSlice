class Image < ApplicationRecord
  validates_presence_of :file_name

  belongs_to :item
end
