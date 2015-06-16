FactoryGirl.define do
  factory :answer do
    sequence(:body)  { |n| "Answer's body #{n}" }
    question
    user

    trait :with_wrong_attributes do
      body nil
    end

    trait :with_attachments do
      transient do
        number_of_attachments 1
      end

      after(:create) do |answer, evaluator|
        create_list(:attachment, evaluator.number_of_attachments, attachable: answer)
      end
    end

    trait :with_comments do
      transient do
        number_of_comments 1
      end

      after(:create) do |answer, evaluator|
        create_list(:comment, evaluator.number_of_attachments, commentable: answer)
      end
    end

    trait :with_votes do
      transient do
        number_of_votes 1
      end

      after(:create) do |answer, evaluator|
        create_list(:vote, evaluator.number_of_votes, votable: answer)
      end
    end

  end
end