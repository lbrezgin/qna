require 'rails_helper'

feature 'User can see his rewards', %q{
  In order to track achievements
  As an answer's author
  I'd like to see my rewards
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:reward) { create(:reward, image: fixture_file_upload("#{Rails.root}/app/assets/images/test_reward.png"), question: question) }

  scenario 'Authenticated user earn reward' do
    sign_in(user)
    visit question_path(question)
    click_on 'Mark as best'

    visit user_rewards_path(user)
    expect(page).to have_content question.title
    expect(page).to have_content reward.title
    expect(page).to have_css("img[src*='test_reward.png']")
  end
end
