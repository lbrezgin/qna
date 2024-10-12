module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_entity, only: [:like, :dislike]
  end

  def like
    prepare_vote(params[:action])
  end

  def dislike
    prepare_vote(params[:action])
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_entity
    @entity = model_klass.find(params[:id])
  end

  def prepare_vote(type)
    respond_to do |format|
      if !(can?(:like, @entity) && can?(:dislike, @entity))
        format.json do
          render json: { error: "You can't vote for your own #{model_klass.to_s.downcase}" }
        end
      else
        @entity.make_vote(current_user, type)
        format.json { render json: @entity.rating }
      end
    end
  end
end
