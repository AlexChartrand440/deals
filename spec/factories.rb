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
    sequence(:description) { |n| "Product description #{n}" }
    sequence(:price) { |n| n }
    seller
  end
end