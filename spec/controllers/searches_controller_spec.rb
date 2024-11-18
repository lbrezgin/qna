require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #search' do
    let!(:query_value) { 'Ruby' }
    let!(:resource_value) { 'Answer' }
    before { allow(controller).to receive(:verify_authenticity_token) }

    it 'calls SearchForResource service' do
      ThinkingSphinx::Test.run do
        expect(SearchForResource).to receive(:search_for).with(query_value, resource_value)
        get :search, params: { query: query_value, resource: resource_value }, format: :js
      end
    end

    it 'renders search template' do
      ThinkingSphinx::Test.run do
        get :search, params: { query: query_value, resource: resource_value }, format: :js
        expect(response).to render_template :search
      end
    end
  end
end
