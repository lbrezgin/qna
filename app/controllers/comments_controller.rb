class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment

  authorize_resource

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.commentable = find_commentable
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def find_commentable
    if params[:question_id]
      Question.find(params[:question_id])
    else
      Answer.find(params[:answer_id])
    end
  end

  def publish_comment
    return if @comment.errors.any?
    case @comment.commentable_type
    when "Question"
      ActionCable.server.broadcast("questions/#{params[:question_id]}/comment", @comment)
    when "Answer"
      ActionCable.server.broadcast("questions/#{@comment.commentable.question_id}/answers/comment", @comment)
    end
  end
end
