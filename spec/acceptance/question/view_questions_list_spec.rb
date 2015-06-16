require_relative '../acceptance_helper'

feature 'User browses a list of questions', %q{
  In order to be able to browse created questions
  As a user
  I want to be able to see a list of existing questions
} do

  given!(:questions){ create_list(:question, 5) }

  scenario 'Guest tries to browse a list of questions' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'User tries to click on question to view answers' do
    visit questions_path
    click_link questions.first.title
    expect(current_path).to eq question_path(questions.first)
  end
end