require 'rails_helper'
require 'shoulda-matchers'

describe Subscription do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:question) }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:question_id) }
end
