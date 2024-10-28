class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    authorize! :index, Question
    @questions = Question.all
    render json: @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    authorize! :show, Question
    @question = Question.find(params[:id])
    render json: @question
  end
end
