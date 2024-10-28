require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    describe 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 5, question: question) }
      let(:answer_response) { json['answers'].first }
      let(:answer) { answers.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq answers.size
      end

      it 'returns all public fields' do
        %w[id body question_id user_id best created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let!(:comments) { create_list(:comment, 3, commentable: answer) }
    let!(:links) { create_list(:link, 2, linkable: answer) }
    let!(:file) { answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain') }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:api_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns answer' do
        expect(api_response['id']).to eq answer.id
      end

      it 'returns all public fields' do
        %w[id body question_id user_id best created_at updated_at].each do |attr|
          expect(api_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it_behaves_like 'API Has many resources' do
        let!(:resource) { answer }
      end
    end
  end
end
