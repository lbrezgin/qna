require 'rails_helper'

feature 'User can create answer', %q{
  In order to help with question
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:guest) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question', js: true do
      fill_in 'Body', with: 'Answers body'
      click_on 'Answer'

      expect(page).to have_content 'Answers body'
    end

    scenario 'answers the question with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers the question attached files', js: true do
      fill_in 'Body', with: 'Answers body'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Answer'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiply sessions' do
    scenario 'answer appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'Test answer'

        click_on 'Answer'
        expect(page).to have_content 'Test answer'
        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test answer'
        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'
      end
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)

    expect(page).to have_content 'You need to sign in to write answer'
  end
end
