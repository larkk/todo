require 'rails_helper'
require 'shoulda-matchers'

describe Vote do
  it { should respond_to :value }

  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :user_id }
  it { should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type])}
  it { should validate_inclusion_of(:value).in_array([-1, 1]) }

  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question }


  [:question, :answer].each do |resource_name|
    before { @resource = send resource_name }

    describe "#{resource_name}" do
      context 'vote up' do
        it { expect{ @resource.vote user, 1 }.to change(@resource.votes, :count).by(1) }

        it 'changes value up to 1' do
          @resource.vote user, 1
          expect(@resource.votes.find_by(user: user).value).to eq 1
        end
      end

      context 'vote down' do
        it { expect{ @resource.vote user, -1 }.to change(@resource.votes, :count).by(1) }

        it 'changes value down to -1' do
          @resource.vote user, -1
          expect(@resource.votes.find_by(user: user).value).to eq -1
        end
      end

      context 'unvote' do
        before { @resource.vote user, 1 }
        it { expect{ @resource.unvote user}.to change(@resource.votes, :count).by(-1) }
      end

      context 'votes total' do
        before { @resource.vote user, 1}
        it { expect(@resource.total_votes).to eq 1 }

        it 'calculates total positive votes' do
          @resource.vote another_user, 1
          expect(@resource.total_votes).to eq 2
        end

        it 'calculates total votes' do
          @resource.vote another_user, -1
          expect(@resource.total_votes).to eq 0
        end
      end
    end
  end
end