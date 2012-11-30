# == Schema Information
#
# Table name: product_descriptions
#
#  id         :integer          not null, primary key
#  product_id :integer
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProductDescription < ActiveRecord::Base
  attr_accessible :text

  belongs_to :product

  validates :product_id, presence: true, uniqueness: true
end
