require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create :user }
  given(:question) { create :question }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when answers the question', js: true do
    fill_in 'create-answer-body', with: 'This is the best answer ever!'
    attach_file 'File', "#{Rails.root}/spec/fixtures/screenshot0.jpg"
    click_on 'Create answer'
    within '.answers' do
      expect(page).to have_link 'screenshot0.jpg', href: '/uploads/attachment/file/1/screenshot0.jpg'
    end
  end

  scenario 'User sees link "Add more"' do
    expect(page).to have_link 'Add more'
  end

  scenario 'User adds several files when creates answer', js: true do
    fill_in 'create-answer-body', with: 'Test Body'

    click_on 'Add more'
    inputs = all('input[type="file"]')
    2.times { |i| inputs[i].set("#{Rails.root}/spec/fixtures/screenshot#{i}.jpg") }
    click_on 'Create answer'

    within '.answers' do
      2.times { |i| expect(page).to have_link "screenshot#{i}.jpg" }
    end
  end

  scenario 'User sees "Remove this file" when fills in a new answer form', js: true do
    click_on 'Add more'
    expect(page).to have_link 'Remove this file'
  end
end