require 'rails_helper'

feature 'User can delete their answers', %q{
  In order to delete answer
  As an authenticated user
  I'd like to be able to destroy answer
} do

  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user' do
    scenario 'tries to delete his answer' do
      sign_in(author)
      visit answer_path(answer)
      click_on 'Delete'

      expect(page).to have_content 'Your answer successfully deleted.'
    end

    scenario 'tries to delete strangers answer' do
      sign_in(non_author)
      visit answer_path(answer)
      click_on 'Delete'

      expect(page).to have_content 'You can not delete answer, which was not created by you.'
    end
  end

  scenario 'Unauthenticated user tries to delete the answer' do
    visit answer_path(answer)
    click_on 'Delete'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
