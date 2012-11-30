# == Schema Information
#
# Table name: products
#
#  id                        :integer          not null, primary key
#  seller_id                 :integer
#  title                     :string(255)
#  price                     :decimal(8, 2)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  slug                      :string(255)
#  status                    :boolean          default(FALSE)
#  quantity                  :integer          default(0)
#  discounted_price          :decimal(8, 2)
#  discounted_percentage_off :integer
#  discount_start_date       :date
#  discount_end_date         :date
#  discount_days_left        :integer
#  for_sale                  :boolean          default(FALSE)
#

require 'uuidtools'
require 'base64'

class Product < ActiveRecord::Base
  attr_accessible :title, :price, :status, :discounted_price, :discount_start_date, :discount_end_date

  #discount end date and start date is inclusive.. meaning if start = 1st, end = 2nd, sale starts 12am on 1st and ends 11.59pm on 2nd.. if start = 1st and end 2nd, it's a 24 hour sale!

  extend FriendlyId
  friendly_id :slug


  #FIX THIS!!! NOT RANDOM ENOUGH!! CAUGHT A DUPLICATE!! AND USE DIGITS!!
  before_create { self.slug = Base64.urlsafe_encode64(UUIDTools::UUID.random_create).downcase[0..5] } #try to use digits instead #I've had a duplicate before #slug created only on once on create to prevent change of slug

  default_scope order: 'products.created_at DESC'

  has_many :images, class_name: "ProductImage", dependent: :destroy #check if when I delete the product, does it delete the image both from database and also s3
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  has_one :description, class_name: "ProductDescription", dependent: :destroy

  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'

  validate :cannot_be_created_by_non_sellers, if: :seller_id?
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :seller_id, presence: true
  validates :title, presence: true
  validates :price, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: false }, :on => :save #on save because slug is only created on create.. not when an item is instantiated

  validates :discount_start_date, presence: true
  validates :discount_end_date, presence: true
  validate :discount_end_date_should_be_same_as_discount_start_date_or_after, if: :discount_start_and_end_date_present
  validate :discount_start_date_should_be_after_today, if: :discount_start_and_end_date_present

  validates :discounted_price, presence: true
  validate :discounted_price_should_be_less_than_regular_price, if: :discounted_price_and_price_present

  private

  def discounted_price_and_price_present
    discounted_price && price
  end

  def discounted_price_should_be_less_than_regular_price
    errors.add(:discounted_price, "is not discounted from regular price") if discounted_price >= price
  end

  def discount_start_and_end_date_present
    discount_start_date && discount_end_date
  end

  def discount_start_date_should_be_after_today #(means tomorrow onwards)
    errors.add(:discount_start_date, "should be after today") if discount_start_date <= Date.today
  end

  def discount_end_date_should_be_same_as_discount_start_date_or_after
    errors.add(:discount_end_date, "is before start date") if discount_end_date < discount_start_date
  end

  def cannot_be_created_by_non_sellers
    unless seller.seller #this checks if the associated seller is a seller or not
      errors.add(:seller, "is not an approved seller")
    end
  end

end
