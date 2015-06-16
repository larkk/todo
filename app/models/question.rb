class Question < ActiveRecord::Base
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :delete_all
  has_many :subscribers, through: :subscriptions, source: :user

  include Votable
  include Attachable
  include Commentable

  after_create :update_reputation

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  scope :created_yesterday, -> { where(created_at: Time.zone.now.yesterday.all_day) }

  def followed_by(user)
    subscriptions.find_by(user: user)
  end

  private
    def update_reputation
      self.delay.calculate_reputation
    end

    def calculate_reputation
      reputation = Reputation.calculate(self)
      self.user.update_attributes(reputation: reputation)
    end
end
