require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

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
        expect { post :create, params: {
          answer: attributes_for(:answer, question: question, user: user).merge(
            links_attributes: [attributes_for(:link, url: 'https://en.wikipedia.org/wiki/Cat', name: 'Cats')]),
            question_id: question.id
        }, format: :js }.to change(Answer, :count).by(1)
      end

      before do
        post :create, params: {
          answer: attributes_for(:answer, question: question, user: user).merge(
            links_attributes: [attributes_for(:link, url: 'https://en.wikipedia.org/wiki/Cat', name: 'Cats')]),
            question_id: question.id
        }, format: :js
      end

      it 'renders create template' do
        expect(response).to render_template :create
      end

      it 'sets correct question in answer' do
        expect(assigns(:answer).question).to eq question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid, question: question, user: user), question_id: question.id }, format: :js }.to_not change(Answer, :count)
      end

      it 'does not save the answer with invalid url' do
        expect { post :create, params: { answer: attributes_for(:answer, question: question, user: user).merge(
          links_attributes: [attributes_for(:link, url: 'invalid url', name: 'Example')] ), question_id: question.id }, format: :js
        }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid, question: question, user: user), question_id: question.id, format: :js }

        expect(response).to render_template :create
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'when current user is not author of the answer' do
      it 'does not destroy the answer, if user_id is wrong' do
        login(non_author)
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(0)
      end
    end

    it 'render destroy' do
      delete :destroy, params: { id: answer }, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let!(:answer) { create(:answer, question: question, user: user ) }
    let!(:non_author) { create(:user) }

    context 'when current user is an author of the answer' do
      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'when current user is not author of the answer' do
        it 'does not update the answer, if user_id is wrong' do
          login(non_author)

          patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
          answer.reload
          expect(answer.body).to_not eq 'new body'
        end
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    before { login(user) }
    let!(:answers) { create_list(:answer, 5, question: question, user: user ) }

    context 'when current user is an author of the question' do
      it 'change answer best from false to true' do
        patch :mark_as_best, params: { id: answers[0], answer: { best: true} }, format: :js
        answers[0].reload

        expect(answers[0].best).to eq true
        expect(question.answers.where(best: true).count).to eq 1
      end

      it 'renders mark as best view' do
        patch :mark_as_best, params: { id: answers[0], answer: { best: true} }, format: :js

        expect(response).to render_template :mark_as_best
      end
    end

    context 'when current user is not author of the question' do
      let!(:non_author) { create(:user) }
      before { login(non_author) }

      it 'does not change answer best attribute' do
        patch :mark_as_best, params: { id: answers[0], answer: { best: true} }, format: :js
        answers[0].reload

        expect(answers[0].best).to eq false
        expect(question.answers.where(best: true).count).to eq 0
      end
    end
  end
end

