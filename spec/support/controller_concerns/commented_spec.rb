require 'rails_helper'

shared_examples 'commented' do
  let!(:resource) { create(described_class.name.underscore.split("_")[0][0..-2].to_sym) }
  let!(:user) { create(:user) }

  describe 'POST #comment' do
    before do
      login(user)
    end

    context 'With valid params' do
      it 'creates new comment' do
        post :comment, params: { comment: {content: "My comment", user: user, commentable: resource}, id: resource.id }, format: :js
        expect(resource.comments[0].commentable).to eq resource
      end
    end

    context 'With invalid params' do
      it 'do not creates new comment' do
        post :comment, params: { comment: {content: nil, user: user, commentable: resource}, id: resource.id }, format: :js
        expect(resource.comments.count).to eq 0
      end
    end
  end
end
