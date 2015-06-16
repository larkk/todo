require_relative '../acceptance_helper'

feature 'Sign out user', %q{
  In order to finish working with site
  As an authenticated user
  I want to be able to sign out
} do
  given(:user) { create :user }

  scenario 'Authenticated user signs out' do
    sign_in(user)
    visit root_path
    expect(page).not_to have_link 'Sign in'
    click_on 'Sign out'
    expect(page).to have_link 'Sign in'
  end

  scenario 'Unauthenticated user tries to sign out' do
    visit root_path
    expect(page).not_to have_link 'Sign out'
    expect(page).to have_link 'Sign in'
  end
end
