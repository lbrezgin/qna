class Api::V1::AnswersController < Api::V1::BaseController
  def index
    authorize! :index, Answer
    @question = Question.find(params[:question_id])
    @answers = @question.answers
    render json: @answers, each_serializer: AnswerCollectionSerializer
  end

  def show
    authorize! :show, Answer
    @answer = Answer.find(params[:id])
    render json: @answer
  end
end
