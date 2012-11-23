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