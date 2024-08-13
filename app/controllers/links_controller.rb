class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    @entity = @link.linkable_type.constantize.where(id: @link.linkable_id).first

    if current_user.author_of?(@entity)
      @link.destroy
    end
  end
end
