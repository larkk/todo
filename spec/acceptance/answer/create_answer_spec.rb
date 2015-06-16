require_relative '../acceptance_helper'

feature 'User tries to create an answer to the question', %q{
  In order to be able to solve an issue
  As a user
  I want to be able to create an answer to the question
} do
  given!(:user) { create :user }
  given!(:question) { create :question }

  scenario 'Authenticated user tries to write an answer to the question', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'create-answer-body', with: 'This is the best answer ever!'
    click_on 'Create answer'
    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'This is the best answer ever!'
    end
  end

  scenario 'User tries to create an invalid answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content "can't be blank"
  end

  scenario 'Unauthenticated user can not create an answer' do
    visit question_path(question)
    expect(page).not_to have_link 'Answer the question'
    expect(page).not_to have_field 'Your answer'
  end
end