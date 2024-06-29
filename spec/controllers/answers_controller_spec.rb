require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #show' do
    let(:answer) { create(:answer, question: question, user: user ) }
    before { get :show, params: { id: answer.id, question_id: question.id } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question.id } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'sets correct question in answer' do
      expect(assigns(:answer).question).to eq question
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a new answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer, question: question, user: user), question_id: question.id } }.to change(Answer, :count).by(1)
      end

      before { post :create, params: { answer: attributes_for(:answer, question: question, user: user), question_id: question.id } }
      it 'redirect to show view' do
        expect(response).to redirect_to answer_path(assigns(:answer))
      end

      it 'sets correct question in answer' do
        expect(assigns(:answer).question).to eq question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid, question: question, user: user), question_id: question.id } }.to_not change(Answer, :count)
      end

      it 'renders questions show view' do
        post :create, params: { answer: attributes_for(:answer, :invalid, question: question, user: user), question_id: question.id }

        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:non_author) { create(:user) }

    context 'when current user is an author of the answer' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end
    end

    context 'when current user is not author of the answer' do
      it 'does not destroy the answer, if user_id is wrong' do
        login(non_author)
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
      end
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(question)
    end
  end
end

