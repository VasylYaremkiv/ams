# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reminder do
    remind_at 2.days.from_now.beginning_of_day + 9.hours
    description 'MyText'

    association :appointment, factory: :appointment

    trait :reminded do
      status Reminder::REMINDED
    end

  end
end
