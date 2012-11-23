FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :seller do
      seller true
    end  

    factory :admin do
      admin true
    end   
  end

  #how do to auto association?

end