class AnswersCommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions/#{params[:question_id]}/answers/comment"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
