

class ProductImageAttribute < ActiveRecord::Base
  attr_accessible :default, :sort_order, :product_id

  belongs_to :product
  belongs_to :image, class_name: "ProductImage", foreign_key: "product_image_id"

  validates :product_id, presence: true
  validates :product_image_id, presence: true
  validates :sort_order,  numericality: {  :allow_blank => true, 
                                           :only_integer => true, greater_than_or_equal_to: 0 },
                          uniqueness: { :scope => :product_id, 
                                        :message => "Images should have uniqueness sort order" }, 
                                        if: :sort_order

  before_save :set_old_default_image_to_false, if: :default #runs only if the default attribute is set to true. If not, save some time and memory!


  private

  def set_old_default_image_to_false
    old_default_product_image = ProductImageAttribute.where(product_id: product_id, default: true)
    old_default_product_image.each do |i|
      i.update_attributes!(default: false) unless i.id == self.id
    end
  end
end
