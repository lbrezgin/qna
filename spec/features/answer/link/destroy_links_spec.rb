require 'rails_helper'

feature 'User can destroy answers links', %q{
  In order to correct mistakes
  As an answer's author
  I'd like to be able to destroy links
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'User destroy link when edit answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Edit'
    within '.answer-links-manage' do
      click_on 'X'
    end
    click_on 'Save'
    expect(page).to_not have_link 'Cats', href: link
  end
end
