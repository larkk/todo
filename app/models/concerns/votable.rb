module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, value)
    vote = votes.find_or_initialize_by(user: user)
    vote.value = value
    vote.save!
  end

  def unvote(user)
    votes.where(user: user).destroy_all
  end

  def voted_by?(user)
    votes.where(user: user).exists?
  end

  def total_votes
    votes.sum :value
  end
end