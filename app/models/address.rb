# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  address_1  :string(255)
#  address_2  :string(255)
#  city       :string(255)
#  post_code  :string(255)
#  state      :string(255)
#  country    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Address < ActiveRecord::Base
  attr_accessible :address_1, :address_2, :city, :country, :post_code, :state

  belongs_to :user

  validates :user_id, presence: true
  validates :address_1, presence: true
  validates :city, presence:true
  validates :country, presence: true
  validates :state, presence: true
  VALID_POSTCODE = /\A[\d+\-.]+\z/i
  validates :post_code, presence: true, format: { with: VALID_POSTCODE }
end
