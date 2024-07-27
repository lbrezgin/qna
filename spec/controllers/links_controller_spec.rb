require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:wrong_user) { create(:user) }
    let!(:link) { create(:link, linkable: question) }

    before { login(user) }

    it 'does not destroy the link, if user_id is wrong' do
      login(wrong_user)
      expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(0)
    end

    it 'deletes the link' do
      expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
    end

    it 'render destroy' do
      delete :destroy, params: { id: link }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
