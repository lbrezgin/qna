require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }


  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    within '.answer' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user which is author' do
    background do
      sign_in(user)
      visit question_path(question)
      within '.answer' do
        click_on 'Edit'
      end
    end

    scenario 'edits his answer', js: true do
      within '.answer' do
        fill_in 'Your answer', with: 'Edited answer'
        attach_file 'Files', "#{Rails.root}/spec/spec_helper.rb"

        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with errors', js: true do
      within '.answer' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
      end
      expect(page).to have_content "Body can't be blank"
    end
  end

  given!(:non_author) { create :user }
  scenario "Authenticated user tries to edit other user's answer", js: true do
    sign_in(non_author)
    visit question_path(question)

    within '.answer' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
