require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  let!(:author) { create(:user) }
  let!(:non_author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }

  describe 'DELETE #destroy' do
    before {
      question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain')
      answer.files.attach(io: File.open(Rails.root.join('spec', 'spec_helper.rb')), filename: 'spec_helper.rb', content_type: 'text/plain')
      question.save
      answer.save
    }

    context 'Authenticated user' do
      before { login(author) }

      it 'destroys the attached file if user is author' do
        delete :destroy, params: { id: question.files.first }, format: :js
        delete :destroy, params: { id: answer.files.first }, format: :js
        question.reload
        answer.reload

        expect(question.files.attached?).to eq false
        expect(answer.files.attached?).to eq false
      end

      it 'do not destroys the attached file if user is not author ' do
        login(non_author)
        delete :destroy, params: { id: question.files.first.id }, format: :js
        delete :destroy, params: { id: answer.files.first.id }, format: :js
        question.reload
        answer.reload

        expect(question.files.attached?).to eq true
        expect(answer.files.attached?).to eq true
      end
    end

    it 'do not destroys the attached file if user is not sign in ' do
      delete :destroy, params: { id: question.files.first }, format: :js
      delete :destroy, params: { id: answer.files.first }, format: :js
      question.reload
      answer.reload

      expect(question.files.attached?).to eq true
      expect(answer.files.attached?).to eq true
    end
  end
end

