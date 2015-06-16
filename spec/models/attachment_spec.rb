require 'rails_helper'
require 'shoulda-matchers'

describe Attachment do
  it { should belong_to :attachable }
end
