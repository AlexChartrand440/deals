# == Schema Information
#
# Table name: product_images
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string(255)
#

class ProductImage < ActiveRecord::Base
  attr_accessible :image

  belongs_to :product
  has_one :attribute, class_name:"ProductImageAttribute", dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :image, presence:true
  validates :product_id, presence:true

  after_create :create_product_image_attribute

  private

  def create_product_image_attribute
    self.create_attribute!(product_id: self.product_id)
  end

end
