require_relative '../acceptance_helper'

feature 'User browses a question and a list of answers', %q{
  In order to be able to solve the issue
  As an user
  I want to have an ability to view a list of answers for the specific question
}do
  given(:question) { create :question, :with_answers, number_of_answers: 5 }
  scenario 'User tries to browse a question and its answers' do

    visit question_path(question)

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end