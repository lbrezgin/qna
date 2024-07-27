require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:wrong_user) { create(:user) }

    before { login(user) }

    context 'When question: ' do
      let!(:question_link) { create(:link, linkable: question) }

      it 'does not destroy the link, if user_id is wrong' do
        login(wrong_user)
        expect { delete :destroy, params: { id: question_link }, format: :js }.to change(Link, :count).by(0)
      end

      it 'deletes the link' do
        expect { delete :destroy, params: { id: question_link }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'render destroy' do
        delete :destroy, params: { id: question_link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'When answer: ' do
      let!(:answer) { create(:answer, question: question, user: user) }
      let!(:answer_link) { create(:link, linkable: answer) }

      it 'does not destroy the link, if user_id is wrong' do
        login(wrong_user)
        expect { delete :destroy, params: { id: answer_link }, format: :js }.to change(Link, :count).by(0)
      end

      it 'deletes the link' do
        expect { delete :destroy, params: { id: answer_link }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'render destroy' do
        delete :destroy, params: { id: answer_link }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end



