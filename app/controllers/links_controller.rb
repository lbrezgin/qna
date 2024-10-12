class LinksController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @link = Link.find(params[:id])
    @entity = @link.linkable_type.constantize.where(id: @link.linkable_id).first

    if can?(:destroy, @entity)
      @link.destroy
    end
  end
end
