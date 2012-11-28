# == Schema Information
#
# Table name: categorizations
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Categorization < ActiveRecord::Base
  attr_accessible :category_id

  belongs_to :category
  belongs_to :product

  validates :category_id, presence: true
  validates :product_id, presence: true
  validates_uniqueness_of :product_id, scope: :category_id

end
