require_relative '../acceptance_helper'

feature 'Delete question', %q{
  In order to be able to get rid of unnecessary question
  As an author
  I want to be able to delete question
} do
  given(:author) { create :user }
  given(:another_user) { create :user }
  given!(:authors_question) { create :question, user: author }
  given!(:another_users_question) { create :question, user: another_user }


  scenario 'Author tries to delete his own question', js: true do
    sign_in(author)
    visit questions_path
    within "#question-#{authors_question.id}" do
      click_on 'Delete'
    end
    expect(page).not_to have_content authors_question.title
    expect(current_path).to eq questions_path
  end

  scenario 'Author tries to delete another users question' do
    sign_in(author)
    visit questions_path
    within "#question-#{another_users_question.id}" do
      expect(page).not_to have_link 'Delete'
    end
  end

  scenario 'Guest tries to delete a question' do
    visit question_path(authors_question)
    expect(page).not_to have_link 'Delete'
  end
end
