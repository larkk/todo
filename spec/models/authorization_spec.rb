require 'rails_helper'
require 'shoulda-matchers'

describe Authorization do
  it { should respond_to :provider }
  it { should respond_to :uid }
end
