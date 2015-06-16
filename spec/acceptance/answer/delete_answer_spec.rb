require_relative '../acceptance_helper'

feature 'Delete answer', %q{
  In order to be able to get rid of unnecessary answer
  As an author
  I want to be able to delete answer
} do
  given(:author) { create :user }
  given(:user) { create :user }
  given(:question) { create :question, user: author }
  given(:question2) { create :question, user: user }
  given!(:authors_answer) { create :answer, question: question, user: author }
  given!(:another_users_answer) { create :answer, question: question2, user: user }

  scenario 'Author tries to delete his own answer', js: true do
    sign_in(author)
    visit question_path(question)
    within "#answer-#{authors_answer.id}" do
      click_on 'Delete answer'
    end
      expect(page).not_to have_content authors_answer.body
      expect(current_path).to eq question_path(question)
  end

  scenario 'Author tries to delete another users answer', js: true do
    sign_in(author)
    visit question_path(question2)
    within "#answer-#{another_users_answer.id}" do
      expect(page).not_to have_link 'Delete answer'
    end
  end

  scenario 'Guest tries to delete an answer' do
    visit question_path(question2)
    expect(page).not_to have_link 'Delete answer'
  end
end