require 'rails_helper'

feature 'User can add reward when creating question', %q{
  In order to give for users rewards for good answer
  As an question's author
  I'd like to be able to add reward
} do

  given!(:user) { create(:user) }
  scenario 'User adds reward when asks question' do
    sign_in(user)
    visit new_user_question_path(user)

    within '.question' do
      fill_in 'Title', with: 'Test title'
      fill_in 'Body', with: 'test body'
    end

    within '.add-reward' do
      fill_in 'Title', with: 'Reward for best answer'
      attach_file 'Image', "#{Rails.root}/app/assets/images/test_reward.png"
    end

    click_on 'Ask'
    expect(page).to have_content 'Reward for best answer'
    expect(page).to have_css("img[src*='test_reward.png']")
  end

  scenario 'User adds reward without title' do

  end

  scenario 'User adds reward without attached image' do

  end
end
