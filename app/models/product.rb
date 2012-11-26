class Product < ActiveRecord::Base
  attr_accessible :description, :price, :seller_id, :title

  has_many :product_images
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id' 
end
