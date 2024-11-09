require 'rails_helper'

feature 'User can destroy subscription', %q{
  In order to stop get notifications about new answers
  As an authenticated user
  I'd like to be able to unsubscribe from the question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'unsubscribe from question', js: true do
      click_on 'Subscribe'
      click_on 'Unsubscribe'

      expect(page).to have_content 'Subscribe'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'does not have opportunity to unsubscribe, because does not have information about current user', js: true do
      visit question_path(question)

      expect(page).to have_content 'You need to sign in to subscribe'
    end
  end
end
