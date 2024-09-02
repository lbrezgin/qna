require 'rails_helper'

feature 'User can destroy questions links', %q{
  In order to correct mistakes
  As an question's author
  I'd like to be able to destroy links
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'User destroy link when edit question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Edit'
      within '.question-links-manage' do
        click_on 'X'
      end
      click_on 'Save'
    end
    expect(page).to_not have_link 'Cats', href: link
  end
end
