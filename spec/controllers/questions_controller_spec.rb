require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    #let и before видны только внутри describe, в который они вложенны
    let(:questions) { create_list(:question, 3) } #выполняется перед одним тестом, ! чтобы перед всеми
    before { get :index } #выполняется перед каждым тестом

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end

