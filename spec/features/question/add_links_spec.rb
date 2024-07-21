require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:link) { 'https://en.wikipedia.org/wiki/Cat' }
  given(:sec_link) { 'https://en.wikipedia.org/wiki/Dog' }

  scenario 'User adds link when asks question', js: true do
     sign_in(user)
     visit new_user_question_path(user)

     fill_in 'Title', with: 'Test question'
     fill_in 'Body', with: 'text text text'

     fill_in 'Link name', with: 'Cats'
     fill_in 'Url', with: link
     click_on 'add link'

     within all('.nested-fields').last do
       fill_in 'Link name', with: 'Dogs'
       fill_in 'Url', with: sec_link
     end
     click_on 'Ask'

     expect(page).to have_link 'Dogs', href: sec_link
     expect(page).to have_link 'Cats', href: link
  end
end
