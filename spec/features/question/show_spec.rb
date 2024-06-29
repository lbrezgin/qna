require 'rails_helper'

feature 'User can see question, and answers to question', %q{
  In order to find answer to question
  As any user
  I'd like to be able to view question and its answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  scenario 'User views question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
