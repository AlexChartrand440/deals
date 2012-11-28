# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  seller_id   :integer
#  title       :string(255)
#  price       :decimal(8, 2)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Product < ActiveRecord::Base
  attr_accessible :description, :price, :title

  has_many :images, class_name: "ProductImage", dependent: :destroy #check if when I delete the product, does it delete the image both from database and also s3
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id' 

  validates :seller_id, presence: true
  validates :title, presence: true
  validates :price, presence: true
end
