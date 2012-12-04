# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE)
#  seller                 :boolean          default(FALSE)
#  first_name             :string(255)
#  last_name              :string(255)
#  brand                  :string(255)
#  slug                   :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :seller, :brand

  extend FriendlyId
  friendly_id :brand, use: :slugged #should allow history?

  def should_generate_new_friendly_id?
    seller? #slug will not change if brand name doesn't change
  end

  has_many :addresses, dependent: :destroy #test this!
  has_many :products, foreign_key: 'seller_id', dependent: :destroy
#   has_many :latest_orders, :class_name => "Order", :conditions => proc { ["orders.created_at > ?", 10.hours.ago] }


  validates :brand, presence: true, uniqueness: { case_sensitive: false }, if: :seller?
  # validates :slug, presence: true, uniqueness: { case_sensitive: false }, if: :seller?

  validates :brand, :length => {:is => 0 }, if: "seller == false"
  validates :slug, :length => {:is => 0 }, if: "seller == false"

end
