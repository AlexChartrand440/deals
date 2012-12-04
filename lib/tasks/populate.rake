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
        product.price = [444.99, 199.95, 100, 600, 132.5, 154.90, 170.80, 200.60]
        product.discounted_price = [19.99, 50, 30.90, 99, 1, 28]
        product.discount_start_date = Date.today - 10..Date.today + 100
        product.discount_end_date = product.discount_start_date + 2..product.discount_start_date + 60
        product.created_at = 2.years.ago..Time.now
        product.updated_at = 2.years.ago..Time.now
        product.slug = Base64.urlsafe_encode64(UUIDTools::UUID.random_create).downcase[0..5]
        ProductDescription.populate 1 do |d|
          d.text = Populator.sentences(2..10)
          d.product_id = product.id
        end
        Categorization.populate 1 do |c|
          c.category_id = category.id
          c.product_id = product.id
        end
      end
    end
  end
end