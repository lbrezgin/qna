require 'rails_helper'

RSpec.describe FindForOauth do
  let!(:user) { create(:user) }
  let!(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: user.email }) }

  subject { FindForOauth.new(auth[:provider], auth[:uid], auth[:info][:email]) }

  context 'user has not authorization' do
    context 'user already exists' do
      let!(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: user.email }) }

      it 'does not create new user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'creates authorization for user' do
        expect { subject.call }.to change(user.authorizations, :count).by(1)
      end

      it 'returns the user' do
        expect(subject.call).to eq user
      end
    end

    context 'user does not exists' do
      let!(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: 'new@user.com' }) }

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject.call).to be_a(User)
      end

      it 'fills user email' do
        user = subject.call
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates authorization for user' do
        user = subject.call
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization).to have_attributes(provider: auth.provider, uid: auth.uid)
      end
    end
  end
end


