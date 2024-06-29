class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:show, :destroy]
  before_action :load_question, only: [:new, :create]

  def show
  end

  def new
    @answer = current_user.answers.new
    @answer.question = @question
  end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question

    if @answer.save
      redirect_to answer_path(@answer), notice: 'Your answer successfully created.'
    else
      render '/questions/show'
    end
  end

  def destroy
    if current_user.author_of(@answer)
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
    params.require(:answer).permit(:body, :question_id)
  end
end
