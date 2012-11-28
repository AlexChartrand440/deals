namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'faker'
    
    [Category, Product, User, Categorization].each(&:delete_all)
    
    100.times do |n|
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

    Category.populate 10 do |category|
      category.name = Populator.words(1..3).titleize
      Product.populate 10..50 do |product|
        product.seller_id = User.all.map { |u| u.id }
        product.title = Populator.words(1..5).titleize
        product.description = Populator.sentences(2..10)
        product.price = [4.99, 19.95, 100]
        product.created_at = 2.years.ago..Time.now
        Categorization.populate 1 do |c|
          c.category_id = category.id
          c.product_id = product.id
        end
      end
    end
  end
end