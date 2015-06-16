FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    password '12345678qwerty'
    password_confirmation '12345678qwerty'

    trait :with_questions do
      transient do
        number_of_questions 4
      end

      after(:create) do |user, evaluator|
        create_list(:question, evaluator.number_of_questions, user: user)
      end
    end
  end
end
