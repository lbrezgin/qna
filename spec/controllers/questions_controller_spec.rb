require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answers) { create_list(:answer, 3, question: question, user: user)}
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns the question answers to @answers' do
      expect(assigns(:answers)).to eq answers
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { user_id: user.id } }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect {
          post :create, params: {
            question: attributes_for(:question).merge(
              links_attributes: [attributes_for(:link, url: 'https://en.wikipedia.org/wiki/Cat', name: 'Cats')],
              reward_attributes: { title: 'Test reward', image: fixture_file_upload("#{Rails.root}/app/assets/images/test_reward.png") }
            ),
            user_id: user.id
          }
        }.to change(Question, :count).by(1)
      end


      it 'redirect to show view' do
        post :create, params: {
          question: attributes_for(:question).merge(
            links_attributes: [attributes_for(:link, url: 'https://en.wikipedia.org/wiki/Cat', name: 'Cats')],
            reward_attributes: { title: 'Test reward', image: fixture_file_upload("#{Rails.root}/app/assets/images/test_reward.png") }
          ),
          user_id: user.id
        }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid, user: user), user_id: user.id } }.to_not change(Question, :count)
      end

      it 'does not save the question with invalid url' do
        expect { post :create, params: { question: attributes_for(:question, user: user).merge(
          links_attributes: [attributes_for(:link, url: 'invalid url', name: 'Example')] ),user_id: user.id }
        }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid, user: user), user_id: user.id }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let!(:non_author) { create(:user) }

    context 'when current user is an author of the question' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question, user: user) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body', user: user} }, format: :js
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
          expect(question.user).to eq user
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question, user: user) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid, user: user) }, format: :js }

        it 'does not change question attributes' do
          question.reload

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'when current user is not author of the question' do
      it 'does not update the question, if user_id is wrong' do
        login(non_author)
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body', user: user} }, format: :js
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question, user: user) }
    let(:wrong_user) { create(:user) }

    it 'does not destroy the question, if user_id is wrong' do
      login(wrong_user)
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
    end

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to user_questions_path(user)
    end
  end
end
