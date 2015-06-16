require_relative '../acceptance_helper'

feature 'Vote for answer', %q{
  In order to choose the best solution
  As an authenticated user
  I'd like to have an opportunity to vote for answer
} do
  given(:user) { create :user }
  given(:author) { create :user }
  given(:question) { create :question, user: author }
  given!(:answer) { create :answer, question: question, user: author }
  given!(:answer_with_votes) { create :answer, :with_votes, number_of_votes: 4, question: question }

  context 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes up', js: true do
      within "#answer-#{answer.id}" do
        click_on 'vote up'
        within '.votes-total' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes down', js: true do
      within "#answer-#{answer.id}" do
        click_on 'vote down'
        within '.votes-total' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'unvotes', js: true do
      within "#answer-#{answer.id}" do
        click_on 'vote up'
        expect(page).to have_content '1'
        click_on 'unvote'
        expect(page).to have_content '0'
      end
    end

    scenario 'sees the correct total rating when vote up', js: true do
      within "#answer-#{answer_with_votes.id}" do
        expect(page).to have_content '4'
        click_on 'vote up'
        expect(page).to have_content '5'
      end
    end

    scenario 'can not vote multiple times for an answer', js: true do
      within "#answer-#{answer.id}" do
        click_on 'vote up'
        expect(page).not_to have_link 'vote up'
        expect(page).not_to have_link 'vote down'
      end
    end

    scenario 'sees the correct total rating when vote down', js: true do
      within "#answer-#{answer_with_votes.id}" do
        expect(page).to have_content '4'
        click_on 'vote down'
        expect(page).to have_content '3'
      end
    end
  end

  context 'Author can not vote for his answer' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'vote un/up/down' do
      within "#answer-#{answer.id}" do
        expect(page).not_to have_link 'vote up'
        expect(page).not_to have_link 'vote down'
        expect(page).not_to have_link 'unvote'
      end
    end
  end

  context 'Unauthenticated user can not vote for any answer' do
    before { visit question_path(question) }

    scenario 'vote un/up/down' do
      expect(page).not_to have_link 'vote up'
      expect(page).not_to have_link 'vote down'
      expect(page).not_to have_link 'unvote'
    end
  end
end