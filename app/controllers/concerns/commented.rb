module Commented
  extend ActiveSupport::Concern

  included do
    before_action :load_commented, only: :comment
  end

  def comment
    @comment = current_user.comments.new(comment_params)
    @comment.commentable = @commentable

    @comment.save
  end

  private

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

