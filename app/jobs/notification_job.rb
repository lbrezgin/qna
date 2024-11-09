class NotificationJob < ApplicationJob
  queue_as :default

  def perform(question)
    Notification.send_notification(question)
  end
end
