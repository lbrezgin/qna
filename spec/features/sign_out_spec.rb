require 'rails_helper'

feature 'User can sign out', %q{
  In order to end work with website
  As an authenticated user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }
  scenario 'Registered and authenticated user tries to sign out' do
    sign_in(user)
    visit user_questions_path(user)

    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
