require 'rails_helper'

shared_examples 'voted' do
  let!(:resource) { create(described_class.name.underscore.split("_")[0][0..-2].to_sym) }
  let!(:user) { create(:user) }

  describe 'PATCH #like' do
    before do
      login(user)
      post :like, params: { id: resource.id }, format: :json
    end

    it 'creates new like' do
      expect(resource.votes[0].votable).to eq resource
    end

    it 'unlike resource' do
      post :like, params: { id: resource.id }, format: :json

      expect(resource.votes.count).to eq 0
    end
  end

  describe 'PATCH #dislike' do
    before do
      login(user)
      post :dislike, params: { id: resource.id }, format: :json
    end

    it 'creates new dislike' do
      expect(resource.votes[0].votable).to eq resource
    end

    it 'undislike resource' do
      post :dislike, params: { id: resource.id }, format: :json

      expect(resource.votes.count).to eq 0
    end
  end
end
