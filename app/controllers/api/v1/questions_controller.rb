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

  def create
    authorize! :create, Question
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question
    else
      render json: @question.errors.full_messages
    end
  end

  def update
    authorize! :update, Question
    @question = Question.find(params[:id])
    @question.update(question_params)
    @question.reload
    render json: @question
  end

  def destroy
    authorize! :destroy, Question
    @question = Question.find(params[:id])
    @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [:name, :url, :_destroy],
                                     reward_attributes: [:title, :image])
  end
end
