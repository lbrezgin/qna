require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:question2) { create(:question, user: user) }
  let!(:reward1) { create(:reward,
                         image: fixture_file_upload("#{Rails.root}/app/assets/images/test_reward.png"),
                         user: user,
                         question: question) }
  let!(:reward2) { create(:reward,
                         image: fixture_file_upload("#{Rails.root}/app/assets/images/test_reward.png"),
                         user: user,
                         question: question2) }
  describe 'GET #index' do
    before { login(user) }
    before { get :index, params: { user_id: user.id } }

    it 'populates an array of all rewards' do
      expect(assigns(:rewards)).to match_array([reward1, reward2])
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
