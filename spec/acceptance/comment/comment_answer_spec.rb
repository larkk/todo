require_relative '../acceptance_helper'

feature 'Comment an answer', %q{
  In order to be able to specify an answer
  As an authenticated user
  I'd like to have an opportunity to comment an answer
} do
  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given!(:answer) { create :answer, user: user, question: question }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates a comment', js: true do
      within "#answer-#{answer.id}" do
        expect(page).not_to have_field 'Your comment'
        click_on 'Add comment'
        fill_in 'Your comment', with: 'New comment'
        click_on 'Submit'
        expect(page).to have_content 'New comment'
        expect(page).to have_content user.email
      end
    end

    scenario 'tries to create an invalid comment', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Add comment'
        click_on 'Submit'
        expect(page).to have_content "can't be blank"
      end
    end
  end

  context 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario 'can not comment a answer' do
      within "#answer-#{answer.id}" do
        expect(page).not_to have_link 'Add comment'
      end
    end
  end
end