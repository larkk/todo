require_relative '../acceptance_helper'

feature 'Remove files from question', %q{
  In order to get rid of unnecessary attachments
  As an author of a question
  I'd like to be able to remove files from the question
} do
  given!(:author) { create :user }
  given!(:user) { create :user }
  given!(:question) { create :question, :with_attachments, user: author }
  given!(:another_question) { create :question, :with_attachments, user: user }
  given!(:attachment) { question.attachments.first }
  given!(:another_users_attachment) { another_question.attachments.first }


  background do
    sign_in(author)
  end

  scenario 'Author sees remove link' do
    visit question_path(question)
    expect(page).to have_link 'Delete file'
  end

  scenario 'Author removes files when edits the question', js: true do
    visit questions_path
    within "#question-#{question.id}" do
      click_on 'Edit'
      within ".file-#{attachment.id}" do
        click_on 'Delete file'
      end
      expect(page).not_to have_content attachment.file.identifier
    end
    expect(current_path).to eq questions_path
  end

  scenario 'Author removes files', js: true do
    visit question_path(question)
    within '.question' do
      within ".file-#{attachment.id}" do
        click_on 'Delete file'
      end
      expect(page).not_to have_content attachment.file.identifier
    end
    expect(current_path).to eq question_path(question)
  end

  scenario "Author can not remove another user's files", js: true do
    visit question_path(another_question)
    within '.question' do
      expect(page).not_to have_link 'Delete file'
    end
  end
end