class AnswersController < ApplicationController
  before_action :load_answer, only: [:show]
  before_action :load_question, only: [:new, :create]

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      redirect_to question_answer_path(@question, @answer)
    else
      render :new
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
