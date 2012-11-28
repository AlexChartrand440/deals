# == Schema Information
#
# Table name: product_images
#
#  id         :integer          not null, primary key
#  product_id :integer
#  image      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProductImage < ActiveRecord::Base
  attr_accessible :image

  belongs_to :product

  mount_uploader :image, ImageUploader

  validates :product_id, presence: true
  validates :image, presence:true
end
