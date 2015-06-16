require_relative '../acceptance_helper'

feature 'Remove files from answer', %q{
  In order to get rid of unnecessary attachments
  As an author of a question
  I'd like to be able to remove files from the answer
} do
  given(:author) { create :user }
  given(:user) { create :user}
  given(:question) { create :question }
  given!(:answer) { create :answer, :with_attachments, question: question, user: author }
  given!(:attachment) { answer.attachments.first }

  scenario 'Author sees remove link' do
    sign_in(author)
    visit question_path(question)
    within '.answers' do
      expect(page).to have_link 'Delete file'
    end
  end

  scenario 'Author removes files when edits the answer', js: true do
    sign_in(author)
    visit question_path(question)
    within "#answer-#{answer.id}" do
      click_on 'Edit'
      within all(".file-#{attachment.id}")[1] do
        click_on 'Delete file'
      end
      expect(page).not_to have_content attachment.file.identifier
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Author removes files', js: true do
    sign_in(author)
    visit question_path(question)
    within '.answers' do
      within ".file-#{attachment.id}" do
        click_on 'Delete file'
      end
      expect(page).not_to have_content attachment.file.identifier
    end
    expect(current_path).to eq question_path(question)
  end

  scenario "Author can not remove another user's files" do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Delete file'
    end
  end
end