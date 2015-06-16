FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Title ##{n}" }
    sequence(:body)  { |n| "Body ##{n}" }
    user

    trait :with_answers do
      transient do
        number_of_answers 4
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.number_of_answers, question: question)
      end
    end

    trait :with_wrong_attributes do
      title nil
      body nil
    end

    trait :with_all_the_best_answers do
      transient do
        number_of_answers 4
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.number_of_answers, question: question, best: true)
      end
    end

    trait :with_attachments do
      transient do
        number_of_attachments 1
      end

      after(:create) do |question, evaluator|
        create_list(:attachment, evaluator.number_of_attachments, attachable: question)
      end
    end
  end
end
