require 'rails_helper'

feature 'User can add reward when creating question', %q{
  In order to give for users rewards for good answer
  As an question's author
  I'd like to be able to add reward
} do

  given!(:user) { create(:user) }
  background do
    sign_in(user)
    visit new_user_question_path(user)

    within '.question-in-new' do
      fill_in 'Title', with: 'Test title'
      fill_in 'Body', with: 'test body'
    end
  end

  scenario 'User adds reward when asks question' do
    within '.add-reward' do
      fill_in 'Title', with: 'Reward for best answer'
      attach_file 'Image', "#{Rails.root}/app/assets/images/test_reward.png"
    end

    click_on 'Ask'
    expect(page).to have_content 'Reward for best answer'
    expect(page).to have_css("img[src*='test_reward.png']")
  end

  scenario 'User adds reward without title' do
    within '.add-reward' do
      attach_file 'Image', "#{Rails.root}/app/assets/images/test_reward.png"
    end

    click_on 'Ask'
    expect(page).to have_content "Reward title can't be blank"
  end

  scenario 'User adds reward without attached image' do
    within '.add-reward' do
      fill_in 'Title', with: 'Reward for best answer'
    end

    click_on 'Ask'
    expect(page).to have_content "Reward image must be attached if title is present"
  end
end
