class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:show, :destroy]
  before_action :load_question, only: [:new, :create]

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to answer_path(@answer), notice: 'Your answer successfully created.'
    else
      render '/questions/show'
    end
  end

  def destroy
    if current_user.id == @answer.user_id
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted.'
    else
      redirect_to question_path(@answer.question), notice: 'You can not delete answer, which was not created by you.'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, :user_id)
  end
end
