require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:link) { 'https://en.wikipedia.org/wiki/Cat' }
  given(:sec_link) { 'https://en.wikipedia.org/wiki/Dog' }

  background do
    sign_in(user)
    visit new_user_question_path(user)

    within '.question-in-new' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end
  end

  scenario 'User adds link when asks question', js: true do
    fill_in 'Link name', with: 'Cats'
    fill_in 'Url', with: link
    click_on 'add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Dogs'
      fill_in 'Url', with: sec_link
    end
    click_on 'Ask'

    expect(page).to have_link 'Dogs', href: sec_link
    expect(page).to have_link 'Cats', href: link
  end

  scenario 'User adds link with invalid url when asks question', js: true do
    fill_in 'Link name', with: 'Cats'
    fill_in 'Url', with: "invalid url"

    click_on 'Ask'

    expect(page).to have_content "Links url is not a valid URL"
    expect(page).to_not have_link 'Cats', href: "invalid url"
  end

  scenario 'User adds link on gist', js: true do
    fill_in 'Link name', with: 'Gist'
    fill_in 'Url', with: "https://gist.github.com/lbrezgin/5a5da66d54c86058e8cf68cdbc1e33e2"

    click_on 'Ask'
    expect(page).to have_content "test gist content"
  end
end
