require 'rails_helper'

feature 'User can add comments for question', %q{
  In order to give personal opinion
  As an authenticated user
  I'd like to be able to add comments to question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Unauthenticated user' do
    scenario 'trie\'s to live a comment for answer', js: true do
      visit question_path(question)

      expect(page).to have_content 'You need to sign in or to leave a comment'
    end
  end

  # <-----------When resource is question--------->
  context 'When resource is question' do
    describe 'Authenticated user' do
      background do
        sign_in(user)
        visit question_path(question)
      end

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
    end
  end

  # <-----------When resource is answer--------->
  context 'When resource is answer' do
    describe 'Authenticated user' do
      background do
        sign_in(user)
        visit question_path(question)
      end

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
    end
  end
end

