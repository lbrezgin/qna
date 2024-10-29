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

  def create
    authorize! :create, Answer
    @question = Question.find(params[:question_id])

    @answer = current_user.answers.new(answer_params)
    @answer.question = @question

    if @answer.save
      render json: @answer
    else
      render json: @answer.errors.full_messages
    end
  end

  def update
    authorize! :update, Answer
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @answer.reload

    render json: @answer
  end

  def destroy
    authorize! :destroy, Answer
    @answer = Answer.find(params[:id])
    @answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id,
                                   files: [], links_attributes: [:name, :url])
  end
end
