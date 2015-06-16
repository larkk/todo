require 'rails_helper'
require 'shoulda-matchers'

describe Comment do
  it { should respond_to :body }

  it { should belong_to :user }
  it { should belong_to :commentable }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :body}
  it { should validate_presence_of :commentable_id}
  it { should validate_presence_of :commentable_type}
end