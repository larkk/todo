require_relative '../acceptance_helper'

feature 'Sign in with facebook', %q{
  In order to ask questions
  As an authenticated user
  I'd like to be able to sign in using facebook
} do

  describe 'Sign in' do
    before do
      OmniAuth.config.test_mode = true
      visit root_path
    end

    it 'successfully' do
      mock_auth_hash(:facebook)
      click_on 'Sign in'
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end

    it 'with invalid credentials' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_link 'Sign in'
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials"'
    end
  end
end