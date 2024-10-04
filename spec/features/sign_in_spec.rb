require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given!(:user) { create(:user, email: "test@gmail.com", confirmed_at: Time.now) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  context 'User tries to sign in using third party services' do
    scenario 'When twitter' do
      click_on 'Sign in with Twitter'

      fill_in 'Email', with: user.email
      click_on 'Submit'

      expect(page).to have_content 'Successfully authenticated from twitter account.'
    end

    scenario 'When github' do
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from github account.'
    end
  end
end





