class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:show, :destroy, :update, :mark_as_best]
  before_action :load_question, only: [:new, :create]

  after_action :publish_answer, only: :create

  authorize_resource

  def mark_as_best
    @answer.mark_as_best
    @question = @answer.question
  end

  def index
  end

  def show
  end

  def new
    @answer = current_user.answers.new(question: @question)
  end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question

    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id,
                                   files: [], links_attributes: [:name, :url])
  end

  def publish_answer
    files = @answer.files.map { |file| file.record.body }
    links = @answer.links.map { |link| [link.name, link.url, link.gist?] }

    return if @answer.errors.any?
    ActionCable.server.broadcast("questions/#{@answer.question_id}", {
      answer: @answer,
      question: @answer.question,
      rating: @answer.rating,
      files: files,
      links: links
    })
  end
end
