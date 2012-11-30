require 'uuidtools'
require 'base64'

namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'faker'
    
    [Category, Product, User, Categorization].each(&:delete_all)
    
    50.times do |n|
      User.create do |u|
        u.first_name = Faker::Name.first_name
        u.last_name = Faker::Name.last_name
        u.email   = Faker::Internet.email
        u.password = "secret"
        u.password_confirmation = "secret"
        u.seller = true
        u.brand = Faker::Company.name + n.to_s
      end
    end

    50.times do |n|
      User.create do |u|
        u.first_name = Faker::Name.first_name
        u.last_name = Faker::Name.last_name
        u.email   = Faker::Internet.email
        u.password = "secret"
        u.password_confirmation = "secret"
        u.seller = false
        # u.brand = Faker::Company.name + n.to_s
      end
    end

    Category.populate 10 do |category|
      category.name = Populator.words(1..3).titleize
      Product.populate 10..50 do |product|
        product.seller_id = User.where(seller: true).map { |u| u.id }
        product.title = Populator.words(1..5).titleize
        product.description = Populator.sentences(2..10)
        product.price = [4.99, 19.95, 100]
        product.created_at = 2.years.ago..Time.now
        product.slug = Base64.urlsafe_encode64(UUIDTools::UUID.random_create).downcase[0..5]
        Categorization.populate 1 do |c|
          c.category_id = category.id
          c.product_id = product.id
        end
      end
    end
  end
end