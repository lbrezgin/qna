class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :load_user, only: [:new, :create]

  after_action :publish_question, only: :create
  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answers = @question.answers.sort_by_best.order(:id)
    @answer.links.new
  end

  def new
    @question = @user.questions.new
    @user = current_user
    @question.links.new
    @question.build_reward
  end

  def edit
  end

  def create
    @question = @user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to user_questions_path(current_user), notice: 'Your question successfully deleted.'
    else
      redirect_to user_questions_path(current_user), notice: 'You can not delete question, which was not created by you.'
    end
  end

  private
  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions', @question)
  end

  def load_user
    @user = User.find(params[:user_id])
  end
  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [:name, :url, :_destroy],
                                     reward_attributes: [:title, :image])
  end
end



