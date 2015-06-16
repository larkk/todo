require 'rails_helper'
require 'shoulda-matchers'

describe Answer do
  let(:question) { create :question, :with_all_the_best_answers }
  let(:another_question) { create :question, :with_all_the_best_answers }
  let(:best_answer) { create :answer, question: question }
  let(:another_best_answer) { create :answer, question: another_question }

  it { should respond_to :body }
  it { should respond_to :best }
  it { should respond_to :question_id }

  it { should belong_to :question }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }

  describe 'the best' do
    before do
      best_answer.set_the_best
      best_answer.reload
    end

    it 'sets to true' do
      expect(best_answer.best).to eq true
    end

    it 'is unique for one question' do
      expect(question.answers.where(best: true).count).to eq 1
    end

    it 'is not unique for several questions' do
      another_best_answer.set_the_best
      another_best_answer.reload
      expect(Answer.where(best: true).count).to eq 2
    end

    it 'should be first' do
      expect(question.answers.first).to eq best_answer
    end
  end

  describe 'reputation' do
    let(:user) { create :user }
    let(:question) { create :question }
    subject { build :answer, user: user, question: question }

    it 'should calculate reputation after create' do
      expect(Reputation).to receive(:calculate).with(subject)
      subject.save!
    end

    it 'should not calculate reputation after update' do
      subject.save!
      expect(Reputation).not_to receive(:calculate)
      subject.update(body: '1234')
    end
  end

  context 'when create' do
    let(:subscriber) { create :user }
    it 'emails to question\'s author' do
      expect(AuthorMailer).to receive(:new_answer)
                                  .with(question.user, anything).and_call_original.exactly(2).times
      create(:answer, question: question)
    end

    it 'emails to subscribers' do
      question.subscribers << subscriber
      expect(SubscriptionMailer).to receive(:new_answer).with(subscriber, anything).exactly(2).and_call_original
      create(:answer, question: question)
    end
  end
end
