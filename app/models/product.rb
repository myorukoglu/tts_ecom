class Product < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  has_many :line_items
  belongs_to :category
end
