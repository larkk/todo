require_relative '../acceptance_helper'

feature 'Search', %q{
  In order to find content
  As a User
  I'd like to be able user search
 } do

  given!(:users) { create_list :user, 2 }
  given!(:questions) { create_list :question, 2 }
  given!(:answers) { create_list :answer, 2 }
  given!(:comments) { create_list :comment, 2 }

  scenario 'User searches for any resource', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'Search', with: 'body'
      select 'Everywhere', from: 'search[filter_option]'
      click_on 'Search'

      %w(questions answers comments).each do |resources|
        eval(resources).each do |res|
          expect(page).to have_content res.body
        end
      end

      users.each do |user|
        expect(page).not_to have_content user.email
      end
    end
  end

  scenario 'User searches for questions only', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'Search', with: 'body'
      select 'Questions', from: 'search[filter_option]'
      click_on 'Search'

      questions.each do |question|
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end

      expect(page).not_to have_content answers.first.body
      expect(page).not_to have_content users.first.email
      expect(page).not_to have_content comments.first.body
    end
  end

  scenario 'User searches for answers only', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'Search', with: 'body'
      select 'Answers', from: 'search[filter_option]'
      click_on 'Search'

      answers.each do |answer|
        expect(page).to have_content answer.body
      end

      expect(page).not_to have_content questions.first.body
      expect(page).not_to have_content users.first.email
      expect(page).not_to have_content comments.first.body
    end
  end

  scenario 'User searches for comments only', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'Search', with: 'body'
      select 'Comments', from: 'search[filter_option]'
      click_on 'Search'

      comments.each do |comment|
        expect(page).to have_content comment.body
      end

      expect(page).not_to have_content answers.first.body
      expect(page).not_to have_content users.first.email
      expect(page).not_to have_content questions.first.body
    end
  end

  scenario 'User searches for users only', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'Search', with: users.first.email
      select 'Users', from: 'search[filter_option]'
      click_on 'Search'

      expect(page).to have_content users.first.email
      expect(page).not_to have_content users.last.email
      expect(page).not_to have_content questions.first.body
    end
  end
end
