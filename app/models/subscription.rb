class Subscription < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question, presence: true
  validates :user_id, uniqueness: { scope: :question_id }
end
