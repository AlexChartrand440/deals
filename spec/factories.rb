FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :seller do
      sequence(:brand) { |n| "brand #{n}"}
      seller true
    end

    factory :admin do
      admin true
    end   
  end

  factory :category do
    sequence(:name) { |n| "Category #{n}" }
  end

  factory :product do
    sequence(:title) { |n| "Product #{n}" }
    sequence(:price) { |n| n }
    sequence(:discounted_price) { |n| n - 1 }
    discount_start_date DateTime.now.tomorrow.to_date
    discount_end_date DateTime.now.tomorrow.to_date + 1
    seller
  end

  factory :product_image do
    image { File.open(File.join(Rails.root, 'app', 'assets', 'images', 'rails.png')) }
    product
  end

  factory :address do
    sequence(:address_1) { |n| "#{n}#{n} Example St. #{n}" }
    sequence(:address_2) { |n| "#{n}#{n} Example St. 2 #{n}" }
    sequence(:city) { |n| "#{n}#{n} City #{n}" }
    sequence(:state) { |n| "#{n}#{n} State #{n}" }
    sequence(:country) { |n| "#{n}#{n} Country #{n}" }
    sequence(:post_code) { |n| "#{n}#{n}#{n}#{n}#{n}" }
    user
  end
end