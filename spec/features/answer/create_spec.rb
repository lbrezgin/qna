require 'rails_helper'

feature 'User can create answer', %q{
  In order to help with question
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit "/questions/#{question.id}"
    end

    scenario 'answers the question' do
      fill_in 'Body', with: 'Answers body'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answers body'
    end

    scenario 'answers the question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit "/questions/#{question.id}"
    fill_in 'Body', with: 'Answers body'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
