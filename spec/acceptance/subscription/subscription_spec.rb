require_relative '../acceptance_helper'

feature 'Subscribe to question', %q(
  In order to receive notifications with a new answer
  As a user
  I want to be able to subscribe and unsubscribe to question
) do
  given(:user) { create :user }
  given(:question) { create :question }

  scenario 'User subscribes to question', js: true do
    sign_in user
    visit question_path(question)

    click_on 'Subscribe'

    within '.subscription' do
      expect(page).not_to have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end
  end

  scenario 'Subscribed user unsubscribes', js: true do
    question.subscribers << user
    sign_in user

    visit question_path(question)

    click_on 'Unsubscribe'

    within '.subscription' do
      expect(page).to have_link 'Subscribe'
      expect(page).not_to have_link 'Unsubscribe'
    end
  end

  scenario 'Guest can not subscribe' do
    visit question_path(question)

    within '.subscription' do
      expect(page).not_to have_link 'Subscribe'
    end
  end
end
