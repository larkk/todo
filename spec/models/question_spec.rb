require 'rails_helper'
require 'shoulda-matchers'

describe Question do
  subject { build :question }

  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:delete_all) }
  it { should have_many(:subscribers) }

  it { should respond_to :user_id }
  it { should respond_to :title }
  it { should respond_to :body }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it { should accept_nested_attributes_for :attachments }

  describe 'reputation' do
    let(:user) { create :user }
    subject { build :question, user: user }

    it 'should calculate reputation after create' do
      expect(Reputation).to receive(:calculate).with(subject)
      subject.save!
    end

    it 'should not calculate reputation after update' do
      subject.save!
      expect(Reputation).not_to receive(:calculate)
      subject.update(title: '1234')
    end
  end
end
