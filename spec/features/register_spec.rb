require 'rails_helper'

feature 'User can register', %q{
  In order to log in
  As user without authentication
  I'd like to be able to register
} do

  context "Unregistered user" do
    scenario 'tries to register' do
      visit new_user_registration_path

      fill_in 'Email', with: 'lewickbrez@gmail.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end
  end

  context "Registrated user" do
    given(:user) { create(:user) }

    scenario 'Registered user tries to register' do
      visit new_user_registration_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end
