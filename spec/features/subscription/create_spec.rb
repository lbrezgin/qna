require 'rails_helper'

feature 'User can create subscription', %q{
  In order to get notifications about new answers
  As an authenticated user
  I'd like to be able to subscribe to question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'subscribes to question', js: true do
      click_on 'Subscribe'
      expect(page).to have_content 'Unsubscribe'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'does not have opportunity to subscribe', js: true do
      visit question_path(question)
      expect(page).to have_content 'You need to sign in to subscribe'
    end
  end
end
