require_relative '../acceptance_helper'

feature 'Edit question', %q{
  In order to be able to fix mistakes
  As an author
  I'd like to have an opportunity to edit question
} do
  given(:author) { create :user }
  given(:user) { create :user }
  given!(:question) { create :question, user: author }
  given!(:another_users_question) { create :question, user: user }

  scenario 'Unauthenticated user tries to edit a question' do
    visit questions_path
    within '.questions' do
      expect(page).not_to have_link 'Edit'
    end
  end

  describe 'Author' do
    before do
      sign_in(author)
      visit questions_path
    end

    scenario 'sees Edit link' do
      within "#question-#{question.id}" do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his own answer', js: true do
      within "#question-#{question.id}" do
        click_on 'Edit'
        fill_in 'Title', with: 'edited title'
        fill_in 'Question', with: 'edited question'
        click_on 'Save'

        expect(page).not_to have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario "tries to edit another user's question" do
      within "#question-#{another_users_question.id}" do
        expect(page).not_to have_link 'Edit'
      end
    end
  end
end

