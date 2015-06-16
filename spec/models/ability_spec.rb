require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, user: user, question: question }
    let(:attachment) { create :attachment, attachable: question }
    let!(:subscription) { create :subscription, user: user, question: question }


    let(:another_user) { create :user }
    let(:another_question) { create :question, user: another_user }
    let(:another_answer) { create :answer, question: another_question, user: another_user }
    let(:another_answer_to_users_question) { create :answer, question: question, user: another_user }
    let(:another_attachment) { create :attachment, attachable: another_question }
    let!(:another_subscription) { create :subscription, user: another_user, question: another_question }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Subscription }

    it { should be_able_to :destroy, Subscription }

    it { should be_able_to :subscribe_to, another_question, user: user}
    it { should_not be_able_to :subscribe_to, question, user: user }

    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, another_question, user: user }

    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, another_answer, user: user }

    it { should be_able_to :destroy, question, user: user }
    it { should_not be_able_to :destroy, another_question, user: user }

    it { should be_able_to :destroy, answer, user: user }
    it { should_not be_able_to :destroy, another_answer, user: user }

    it { should be_able_to :destroy, attachment, user: user }
    it { should_not be_able_to :destroy, another_attachment, user: user }

    it { should be_able_to :destroy, subscription, user: user }
    it { should_not be_able_to :destroy, another_subscription, user: user }

    it { should be_able_to :vote_up, another_question, user: user }
    it { should be_able_to :vote_up, another_answer, user: user }
    it { should_not be_able_to :vote_up, question, user: user }
    it { should_not be_able_to :vote_up, answer, user: user }

    it { should be_able_to :vote_down, another_question, user: user }
    it { should be_able_to :vote_down, another_answer, user: user }
    it { should_not be_able_to :vote_down, question, user: user }
    it { should_not be_able_to :vote_down, answer, user: user }

    it { should_not be_able_to :unvote, question, user: user }
    it { should_not be_able_to :unvote, answer, user: user }

    it { should be_able_to :set_the_best, answer, user: user }
    it { should be_able_to :set_the_best, another_answer_to_users_question, user: user }
    it { should_not be_able_to :set_the_best, another_answer, user: user }
  end
end
