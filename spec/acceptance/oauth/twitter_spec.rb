require_relative '../acceptance_helper'

feature 'Sign in with twitter', %q{
  In order to ask questions
  As an authenticated user
  I'd like to be able to sign in using twitter
} do

  before do
    OmniAuth.config.test_mode = true
    visit root_path
    click_on 'Sign in'
    mock_auth_hash(:twitter)
  end

  describe 'update email' do
    let(:user) { create :user, email: 'change-my-email@email.com' }
    before { click_on 'Sign in with Twitter' }

    scenario 'successfuly' do
      fill_in 'auth_info_email', with: 'test@test.com'
      click_on 'Submit'
      expect(page).to have_content 'Successfully authenticated from Twitter account'
    end

    scenario 'when it has not been updated' do
      click_on 'Submit'
      expect(page).to have_content 'Email is required to compete sign up'
    end
  end


  scenario 'with invalid credentials' do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    click_on 'Sign in with Twitter'
    expect(page).to have_content 'Could not authenticate you from Twitter because "Invalid credentials"'
  end
end

