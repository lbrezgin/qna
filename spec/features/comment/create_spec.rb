require 'rails_helper'

feature 'User can add comments for question', %q{
  In order to give personal opinion
  As an authenticated user
  I'd like to be able to add comments to question
} do

  given!(:user) { create(:user) }
  given!(:guest) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Unauthenticated user' do
    scenario 'trie\'s to live a comment for answer', js: true do
      visit question_path(question)

      expect(page).to have_content 'You need to sign in or to leave a comment'
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    # <-----------When resource is question--------->
    context 'When resource is question' do
      scenario 'trie\'s to live a comment for question', js: true do
        within '.question' do
          fill_in 'Content', with: 'This is a comment'
          click_on 'Comment'
        end
        expect(page).to have_content 'This is a comment'
      end

      scenario 'trie\'s to live a comment without content for question', js: true do
        within '.question' do
          click_on 'Comment'
        end
        expect(page).to have_content 'Content can\'t be blank'
      end

      context 'multiply sessions for question\'s comment'  do
        scenario 'comment for question appears on another user\'s page' do
          Capybara.using_session('user') do
            sign_in(user)
            visit question_path(question)
          end

          Capybara.using_session('guest') do
            visit question_path(question)
          end

          Capybara.using_session('user') do
            within '.question' do
              fill_in 'Content', with: 'This is a comment'
              click_on 'Comment'
            end
            expect(page).to have_content 'This is a comment'
          end

          Capybara.using_session('guest') do
            expect(page).to have_content 'This is a comment'
          end
        end
      end
    end

    # <-----------When resource is answer--------->
    context 'When resource is answer' do
      scenario 'trie\'s to live a comment for question', js: true do
        within '.answer' do
          fill_in 'Content', with: 'This is a comment for answer'
          click_on 'Comment'
        end
        expect(page).to have_content 'This is a comment for answer'
      end

      scenario 'trie\'s to live a comment without content for answer', js: true do
        within '.answer' do
          click_on 'Comment'
        end
        expect(page).to have_content 'Content can\'t be blank'
      end

      context 'multiply sessions for answer\'s comment'  do
        scenario 'comment for answer appears on another user\'s page' do
          Capybara.using_session('user') do
            sign_in(user)
            visit question_path(question)
          end

          Capybara.using_session('guest') do
            visit question_path(question)
          end

          Capybara.using_session('user') do
            within '.answer' do
              fill_in 'Content', with: 'This is a comment'
              click_on 'Comment'
            end
            expect(page).to have_content 'This is a comment'
          end

          Capybara.using_session('guest') do
            expect(page).to have_content 'This is a comment'
          end
        end
      end
    end
  end
end



