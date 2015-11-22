# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :appointment do
    start_at 2.days.from_now.beginning_of_day + 10.hours
    description 'MyText'

    association :user, factory: :user

    trait :cancelled do
      status Appointment::CANCELLED
    end
  end
end
