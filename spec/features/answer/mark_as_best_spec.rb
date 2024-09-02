require 'rails_helper'

feature 'User can choose the best answer', %q{
  In order to help other people with the best answer
  As an author of question
  I'd like to be able to choose the best answer for question
} do

  given!(:author) { create(:user) }
  given!(:non_author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user' do
    scenario 'tries to choose best answer for his question', js: true do
      sign_in(author)
      visit question_path(question)
      click_on 'Mark as best'

      expect(page).to have_content '(Best answer by question\'s author opinion)'
    end

    scenario "tries to choose best answer for stranger's question", js: true do
      sign_in(non_author)
      visit question_path(question)

      expect(page).to_not have_link 'Mark as best'
    end
  end

  scenario 'Unauthenticated user tries to choose best answer', js: true do
    sign_in(non_author)
    visit question_path(question)

    expect(page).to_not have_link 'Mark as best'
  end
end
