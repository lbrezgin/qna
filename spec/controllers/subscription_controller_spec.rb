require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do

    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    context 'Authenticated user' do
      before do
        login(user)
      end

      it 'creates subscription' do
        expect { post :create, params: { user_id: user.id, question_id: question.id }, format: :js }.to change(Subscription, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { user_id: user.id, question_id: question.id }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'Unauthenticated user' do
      it 'does not create subscription' do
        expect { post :create, params: { user_id: user.id, question_id: question.id }, format: :js }.to change(Subscription, :count).by(0)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:subscription) { create(:subscription, user: user, question: question) }

    let!(:other_user) { create(:user) }
    let!(:other_subscription) { create(:subscription, user: other_user, question: question) }

    context 'Authenticated user' do
      context 'Own subscription' do
        before do
          login(user)
        end

        it 'destroys subscription' do
          expect { delete :destroy, params: { id: subscription.id }, format: :js }.to change(Subscription, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: subscription.id }, format: :js
          expect(response).to render_template(:destroy)
        end
      end

      context 'Strangers subscription' do
        it 'does not destroy strangers subscription' do
          expect { delete :destroy, params: { id: other_subscription.id }, format: :js }.to change(Subscription, :count).by(0)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not destroy subscription' do
        expect { delete :destroy, params: { id: subscription.id }, format: :js }.to change(Subscription, :count).by(0)
      end
    end
  end
end
