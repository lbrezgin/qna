require 'rails_helper'

feature 'User can delete attached files', %q{
  In order to delete attached files
  As authenticated author of entity
  I want to be able to delete attached files
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in(user)
    question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain')
    answer.files.attach(io: File.open(Rails.root.join('spec', 'spec_helper.rb')), filename: 'spec_helper.rb', content_type: 'text/plain')

    question.save
    answer.save
  end

  describe 'Authenticated author' do
    scenario 'tries to delete attached file when edit question', js: true do
      visit question_path(question)

      click_on 'Edit question'
      click_on 'X'
      click_on 'Save'
      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'tries to delete attached file when edit answer', js: true do
      visit question_path(question)

      click_on 'Edit'
      click_on 'X'
      click_on 'Save'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end
end
