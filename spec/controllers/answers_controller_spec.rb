require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #show' do
    let(:answer) { create(:answer, question_id: question.id ) }
    before { get :show, params: { id: answer.id, question_id: question.id } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'sets correct question in answer' do
      expect(assigns(:answer).question.id).to eq question.id
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save a new answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer, question_id: question.id), question_id: question.id } }.to change(Answer, :count).by(1)
      end
      before { post :create, params: { answer: attributes_for(:answer, question_id: question.id), question_id: question.id } }

      it 'redirect to show view' do
        expect(response).to redirect_to question_answer_path(assigns(:question), assigns(:answer))
      end

      it 'sets correct question in answer' do
        expect(assigns(:answer).question_id).to eq question.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid, question_id: question.id), question_id: question.id } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid, question_id: question.id), question_id: question.id }
        expect(response).to render_template :new
      end
    end
  end
end


