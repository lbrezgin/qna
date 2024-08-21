require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }
  given(:guest) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit user_questions_path(user)
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      within '.question' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached files' do
      within '.question' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      end
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiply sessions' do
    scenario 'question appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit user_questions_path(user)
      end

      Capybara.using_session('guest') do
        visit user_questions_path(guest)
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        within '.question' do
          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'text text text'
        end
        click_on 'Ask'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit user_questions_path(user)

    expect(page).to have_content 'You need to sign in to write question'
  end
end
