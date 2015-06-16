class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  include Votable
  include Attachable
  include Commentable

  validates :body, presence: true
  validates :question_id, presence: true
  validates :user_id, presence: true

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  after_create :calculate_rating
  after_create :notify_author
  after_create :notify_subscribers

  def set_the_best
    Answer.transaction do
      Answer.where(question_id: question_id, best: true).update_all(best: false)
      self.update(best: true)
    end
  end

  private
    def calculate_rating
      Reputation.delay.calculate(self)
    end

    def notify_author
      AuthorMailer.new_answer(question.user, self).deliver_later
    end

    def notify_subscribers
      question.subscribers.each do |subscriber|
        SubscriptionMailer.new_answer(subscriber, self).deliver_later
      end
    end
end
