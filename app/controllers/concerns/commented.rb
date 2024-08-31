module Commented
  extend ActiveSupport::Concern

  included do
    before_action :load_commented, only: :comment
    after_action :publish_comment, only: :comment
  end

  def comment
    @comment = current_user.comments.new(comment_params)
    @comment.commentable = @commentable

    @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?
    case @comment.commentable_type
    when "Question"
      ActionCable.server.broadcast("questions/#{Question.find(params[:id]).id}/comment", @comment)
    when "Answer"
      ActionCable.server.broadcast("questions/#{Answer.find(params[:id]).question.id}/answers/comment", @comment)
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def load_commented
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end

