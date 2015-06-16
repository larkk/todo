require_relative '../acceptance_helper'

feature 'User registration', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign up
} do
  given(:user) { create :user }

  scenario 'Non-existed user tries to sign up' do
    visit root_path
    click_on 'Register'
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Existed user tries to sign up' do
    visit root_path
    click_on 'Register'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end