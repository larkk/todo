require_relative '../acceptance_helper'

feature 'Answer edit', %q{
  In order to fix mistake
  As an author of answer
  I'd like to be able to edit my answer
} do
  given(:author) { create :user }
  given(:another_user) { create :user }
  given!(:question) { create :question, user: author }
  given!(:answer) { create :answer, question: question, user: author }
  given!(:another_user_answer) { create :answer, question: question, user: another_user }

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Author' do
    before do
      sign_in author
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his own answer', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
        expect(page).to have_link 'Edit'
        expect(page).to have_link 'Delete'
      end
    end

    scenario 'tries to submit an empty edit form', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Answer', with: ' '
        click_on 'Save'

        expect(page).to have_content "can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      within "#answer-#{another_user_answer.id}" do
        expect(page).not_to have_link('Edit')
      end
    end
  end
end
