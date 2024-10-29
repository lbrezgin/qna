require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let!(:comments) { create_list(:comment, 3, commentable: question) }
    let!(:links) { create_list(:link, 2, linkable: question) }
    let!(:file) { question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain') }

    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:api_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns question' do
        expect(json['question']['id']).to eq question.id
      end

      it 'returns all public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(api_response[attr]).to eq question.send(attr).as_json
        end
      end

      it_behaves_like 'API Has many resources' do
        let!(:resource) { question }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:api_response) { json['question'] }

      context 'request without params' do
        before { post api_path, params: { access_token: access_token.token, question: { title: nil, body: nil }, user_id: user }}

        it 'returns error message if no params was given' do
          expect(json).to eq ["Title can't be blank", "Body can't be blank"]
        end
      end

      context 'request with valid params' do
        before { post api_path, params: { access_token: access_token.token, question: { title: "new title", body: "new body"}, user_id: user }}

        it 'returns question' do
          expect(api_response['title']).to eq "new title"
          expect(api_response['body']).to eq "new body"
          expect(api_response['user_id']).to eq user.id.as_json
        end
      end
    end
  end


  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:api_response) { json['question'] }

      context 'request without params' do
        before { patch api_path, params: {id: question, access_token: access_token.token, question: { title: nil, body: nil }, user_id: user }}

        it 'don\'t change question if params are not valid ' do
          expect(api_response['title']).to eq question.title.as_json
          expect(api_response['body']).to eq question.body.as_json
        end
      end

      context 'request with valid params' do
        before { patch api_path, params: {id: question, access_token: access_token.token, question: { title: 'updated title', body: 'updated body' }, user_id: user }}

        it 'returns question' do
          expect(api_response['title']).to eq "updated title"
          expect(api_response['body']).to eq "updated body"
          expect(api_response['user_id']).to eq user.id.as_json
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:api_response) { json['question'] }

      context 'request with valid params' do
        before { delete api_path, params: {id: question, access_token: access_token.token }}

        it 'delete question' do
          expect(Question.where(id: question.id)).to eq []
        end
      end
    end
  end
end
