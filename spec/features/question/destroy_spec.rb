require 'rails_helper'

feature 'User can delete their question', %q{
  In order to delete question
  As an authenticated user
  I'd like to be able to destroy question
} do

  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    scenario 'tries to delete his question' do
      sign_in(author)
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Your question successfully deleted.'
    end

    scenario 'tries to delete strangers question' do
      sign_in(non_author)
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'You can not delete question, which was not created by you.'
    end
  end

  scenario 'Unauthenticated user tries to delete the question' do
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
