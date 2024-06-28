require 'rails_helper'

feature 'User can delete their answers', %q{
  In order to delete answer
  As an authenticated user
  I'd like to be able to destroy answer
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user_id: user1.id) }
  given(:answer) { create(:answer, question_id: question.id, user_id: user1.id) }

  describe 'Authenticated user' do
    scenario 'tries to delete his answer' do
      sign_in(user1)
      visit answer_path(answer)
      click_on 'Delete'

      expect(page).to have_content 'Your answer successfully deleted.'
    end

    scenario 'tries to delete strangers answer' do
      sign_in(user2)
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
