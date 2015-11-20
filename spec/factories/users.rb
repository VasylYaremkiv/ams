FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "john#{n}@example.com" }
    password '12345678'
    role User::CUSTOMER

    trait :admin do
      role User::ADMIN
    end

  end

end