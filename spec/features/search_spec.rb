require 'sphinx_helper'

feature 'User can search for resources', %q{
  In order to find needed resource or resources
  As an authenticated user
  I'd like to be able to search for the resources
} do

  describe 'Resource(s) is question(s)' do
    given!(:user) { create(:user) }
    given!(:match_quest_one) { create(:question, title: "Question about Ruby") }
    given!(:match_quest_two) { create(:question, title: "Ruby error") }
    given!(:match_quest_three) { create(:question, title: "Object oriented programming in Ruby") }

    given!(:do_not_match_question) { create(:question, title: "Question about Java") }
    background do
      visit user_questions_path(user)
    end
    scenario 'User searches for the questions', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: "Ruby"
        select 'Question', from: 'resource'
        click_on 'Search'

        within '.sphinx_search_result' do
          expect(page).to have_content match_quest_one.title
          expect(page).to have_content match_quest_two.title
          expect(page).to have_content match_quest_three.title

          expect(page).to_not have_content do_not_match_question.title
        end
      end
    end

    scenario 'User searches for the specific question', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: match_quest_one.title
        select 'Question', from: 'resource'
        click_on 'Search'

        within '.sphinx_search_result' do
          expect(page).to have_content match_quest_one.title

          expect(page).to_not have_content match_quest_two.title
          expect(page).to_not have_content match_quest_three.title
          expect(page).to_not have_content do_not_match_question.title
        end
      end
    end
  end

  describe 'Resource(s) is answer(s)' do
    given!(:user) { create(:user) }
    given!(:match_answer_one) { create(:answer, body: "Answer about Ruby") }
    given!(:match_answer_two) { create(:answer, body: "Ruby error") }
    given!(:match_answer_three) { create(:answer, body: "Object oriented programming in Ruby") }

    given!(:do_not_match_answer) { create(:answer, body: "Answer about Java") }
    background do
      visit user_questions_path(user)
    end
    scenario 'User searches for the answers', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: "Ruby"
        select 'Answer', from: 'resource'
        click_on 'Search'

        within '.sphinx_search_result' do
          expect(page).to have_content match_answer_one.body
          expect(page).to have_content match_answer_two.body
          expect(page).to have_content match_answer_three.body

          expect(page).to_not have_content do_not_match_answer.body
        end
      end
    end

    scenario 'User searches for the specific answer', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: "Answer about Ruby"
        select 'Answer', from: 'resource'
        click_on 'Search'

        within '.sphinx_search_result' do
          expect(page).to have_content match_answer_one.body

          expect(page).to_not have_content match_answer_two.body
          expect(page).to_not have_content match_answer_three.body
          expect(page).to_not have_content do_not_match_answer.body
        end
      end
    end
  end

  describe 'Resource(s) is comment(s)' do
    given!(:user) { create(:user) }
    given!(:match_comment_one) { create(:comment, content: "Comment about Ruby") }
    given!(:match_comment_two) { create(:comment, content: "Ruby error") }
    given!(:match_comment_three) { create(:comment, content: "Object oriented programming in Ruby") }

    given!(:do_not_match_comment) { create(:comment, content: "Comment about Java") }
    background do
      visit user_questions_path(user)
    end
    scenario 'User searches for the comments', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: "Ruby"
        select 'Comment', from: 'resource'
        click_on 'Search'

        within '.sphinx_search_result' do
          expect(page).to have_content match_comment_one.content
          expect(page).to have_content match_comment_two.content
          expect(page).to have_content match_comment_three.content

          expect(page).to_not have_content do_not_match_comment.content
        end
      end
    end

    scenario 'User searches for the specific comment', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: match_comment_one.content
        select 'Comment', from: 'resource'
        click_on 'Search'

        within '.sphinx_search_result' do
          expect(page).to have_content match_comment_one.content

          expect(page).to_not have_content match_comment_two.content
          expect(page).to_not have_content match_comment_three.content
          expect(page).to_not have_content do_not_match_comment.content
        end
      end
    end
  end

  describe 'Resource is user' do
    given!(:user) { create(:user) }
    given!(:user_one) { create(:user) }
    given!(:user_two) { create(:user) }

    background do
      visit user_questions_path(user)
    end
    scenario 'User searches for the user', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: user_one.email
        select 'User', from: 'resource'
        click_on 'Search'

        within '.sphinx_search_result' do
          expect(page).to have_content user_one.email

          expect(page).to_not have_content user_two.email
        end
      end
    end
  end

  describe 'Resource is any resource from all' do
    given!(:user) { create(:user) }
    given!(:match_quest_one) { create(:question, title: "Question about Ruby") }
    given!(:match_answer_one) { create(:answer, body: "Answer about Ruby") }
    given!(:match_comment_one) { create(:comment, content: "Comment about Ruby") }
    background do
      visit user_questions_path(user)
    end

    scenario 'User searches for the suitable resource', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        fill_in 'Query', with: "Ruby"
        select 'All', from: 'resource'
        click_on 'Search'

        within '.sphinx_search_result' do
          expect(page).to have_content match_quest_one.title
          expect(page).to have_content match_answer_one.body
          expect(page).to have_content match_comment_one.content
        end
      end
    end
  end
end
