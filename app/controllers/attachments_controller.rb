class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  before_action :set_attachment, only: [:destroy]
  before_action :set_entity, only: [:destroy]

  def destroy
    if current_user.author_of?(@entity)
      @attachment.purge
    end
  end

  private

  def set_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def set_entity
    set_attachment
    @entity = find_entity(@attachment).find(@attachment.record_id)
  end

  def find_entity(attachment)
    case attachment.record_type
    when "Question"
      return Question
    when "Answer"
      return Answer
    end
  end
end

