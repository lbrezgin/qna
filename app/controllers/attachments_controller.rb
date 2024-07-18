class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @entity = find_entity(@attachment).find(@attachment.record_id)

    if current_user.author_of?(@entity)
      @attachment.purge
    end
  end

  private

  def find_entity(attachment)
    case attachment.record_type
    when "Question"
      return Question
    when "Answer"
      return Answer
    end
  end
end
