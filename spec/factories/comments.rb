FactoryGirl.define do
  factory :comment do
    sequence(:body)  { |n| "Comment's body #{n}" }
    user
    commentable_type { %w(Question Answer).sample }
    sequence(:commentable_id) { |n| n }

    trait :with_wrong_attributes do
      body nil
    end
  end
end
