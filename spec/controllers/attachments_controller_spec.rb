require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  let!(:author) { create(:user) }
  let!(:non_author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }

  describe 'DELETE #destroy' do
    context 'When question:' do
      before do
        question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain')
        question.save
      end

      context 'Authenticated user' do
        it 'destroys the attached file if he is author' do
          login(author)
          delete :destroy, params: { id: question.files.first }, format: :js
          question.reload

          expect(question.files.attached?).to eq false
        end

        it 'do not destroys the attached file if he is not author ' do
          login(non_author)
          delete :destroy, params: { id: question.files.first.id }, format: :js
          question.reload

          expect(question.files.attached?).to eq true
        end
      end

      it 'do not destroys the attached file if user is not sign in ' do
        delete :destroy, params: { id: question.files.first }, format: :js
        question.reload

        expect(question.files.attached?).to eq true
      end
    end

    context 'When answer:' do
      before do
        answer.files.attach(io: File.open(Rails.root.join('spec', 'spec_helper.rb')), filename: 'spec_helper.rb', content_type: 'text/plain')
        answer.save
      end

      context 'Authenticated user' do
        it 'destroys the attached file if he is author' do
          login(author)
          delete :destroy, params: { id: answer.files.first }, format: :js
          answer.reload

          expect(answer.files.attached?).to eq false
        end

        it 'do not destroys the attached file if he is not author ' do
          login(non_author)
          delete :destroy, params: { id: answer.files.first }, format: :js
          answer.reload

          expect(answer.files.attached?).to eq true
        end
      end

      it 'do not destroys the attached file if user is not sign in ' do
        delete :destroy, params: { id: answer.files.first }, format: :js

        answer.reload
        expect(answer.files.attached?).to eq true
      end
    end
  end
end


