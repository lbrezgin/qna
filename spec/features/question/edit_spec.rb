require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario "Unauthenticated can not edit question" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(author)

      visit question_path(question)
      click_on 'Edit question'

      fill_in 'New title', with: 'Edited title'
      fill_in 'New body', with: 'Edited body'

      click_on 'Save'

      within '.question' do
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in(author)

      visit question_path(question)
      click_on 'Edit question'

      fill_in 'New title', with: ''
      fill_in 'New body', with: ''

      click_on 'Save'

      within '.question' do
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end

      within '.question-errors' do
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    given!(:non_author) { create :user }
    scenario "tries to edit other user's question", js: true do
      sign_in(non_author)
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
