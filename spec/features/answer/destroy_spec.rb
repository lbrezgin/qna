require 'rails_helper'

feature 'User can delete their answers', %q{
  In order to delete answer
  As an authenticated user
  I'd like to be able to destroy answer
} do

  given!(:author) { create(:user) }
  given!(:non_author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user' do
    scenario 'tries to delete his answer', js: true do
      sign_in(author)
      visit question_path(question)

      within '.answer' do
        click_on 'Delete'
      end

      expect(page).to have_content 'Answer deleted successfully'
    end

    scenario 'tries to delete strangers answer', js: true do
      sign_in(non_author)
      visit question_path(question)

      within '.answer' do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete the answer', js: true do
    visit question_path(question)

    within '.answer' do
      expect(page).to_not have_link 'Delete'
    end
  end
end
