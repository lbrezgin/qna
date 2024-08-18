require 'rails_helper'

feature 'User can dislike resource ', %q{
  In order to give personal attitude
  As an author of entity
  I want to be able to dislike resource
} do

  given!(:author) { create :user }
  given!(:non_author) { create :user }
  given!(:question) { create :question, user: author }
  given!(:answer) { create :answer, question: question, user: author }

  describe 'Authenticated user' do
    context '(when resource is question)' do
      background do
        sign_in(non_author)
        visit question_path(question)
        within '.question' do
          click_on 'Dislike'
        end
      end

      scenario 'tries to dislike other user\'s question' do
        within '.question' do
          expect(page).to have_content "-1"
        end
      end

      scenario 'tries to dislike other user\'s question again' do
        within '.question' do
          click_on 'Dislike'
          expect(page).to have_content "0"
        end
      end

      scenario 'tries to dislike his question' do
        sign_out
        sign_in(author)
        visit question_path(question)
        within '.question' do
          click_on 'Dislike'

          expect(page).to have_content 'You can\'t vote for your own question'
        end
      end
    end

    context '(when resource is answer)' do
      background do
        sign_in(non_author)
        visit question_path(question)
        within '.answers' do
          click_on 'Dislike'
        end
      end

      scenario 'tries to dislike other user\'s answer' do
        within '.answers' do
          expect(page).to have_content "-1"
        end
      end

      scenario 'tries to dislike other user\'s answer again' do
        within '.answers' do
          click_on 'Dislike'
          expect(page).to have_content "0"
        end
      end

      scenario 'tries to dislike his answer' do
        sign_out
        sign_in(author)
        visit question_path(question)
        within '.answers' do
          click_on 'Dislike'

          expect(page).to have_content 'You can\'t vote for your own answer'
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    context '(when resource is question)' do
      scenario 'tries to vote' do
        visit question_path(question)
        within '.question' do
          click_on 'Dislike'

        end
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end

    context '(when resource is answer)' do
      scenario 'tries to vote' do
        visit question_path(question)
        within '.answers' do
          click_on 'Dislike'

        end
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end
    end
  end
end

