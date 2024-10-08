require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  let!(:user) { create(:user) }
  let!(:oauth_data) { {provider: 'github', uid: 123, info: {email: user.email} } }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
    end

    it 'assigns user to @user' do
      get :github
      expect(assigns(:user)).to eq user
    end

    it 'authenticates user' do
      get :github
      expect(response).to redirect_to root_path
    end
  end

  describe 'Twitter' do
    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
    end

    it 'assigns user to @user' do
      get :twitter
      expect(assigns(:user)).to eq user
    end

    it 'authenticates user' do
      get :twitter
      expect(response).to redirect_to root_path
    end
  end
end
