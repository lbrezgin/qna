require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) {create(:answer, user: user, question: question)}

  describe 'POST #create' do
    before do
      login(user)
    end
    #<---------commenting question--------->
    context 'When commenting question' do
      context 'With valid params' do
        it 'creates new comment' do
          post :create, params: { comment: {content: "My comment", user: user, commentable: question}, question_id: question.id }, format: :js
          expect(question.comments[0].commentable).to eq question
        end
      end

      context 'With invalid params' do
        it 'do not creates new comment' do
          post :create, params: { comment: {content: nil, user: user, commentable: question}, question_id: question.id }, format: :js
          expect(question.comments.count).to eq 0
        end
      end
    end

    #<---------commenting answer--------->
    context 'When commenting answer' do
      context 'With valid params' do
        it 'creates new comment' do
          post :create, params: { comment: {content: "My comment", user: user, commentable: answer}, answer_id: answer.id }, format: :js
          expect(answer.comments[0].commentable).to eq answer
        end
      end

      context 'With invalid params' do
        it 'do not creates new comment' do
          post :create, params: { comment: {content: nil, user: user, commentable: answer}, answer_id: answer.id }, format: :js
          expect(answer.comments.count).to eq 0
        end
      end
    end
  end
end



