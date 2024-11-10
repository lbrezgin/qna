class NotificationJob < ApplicationJob
  queue_as :default

  def perform(question)
    SendNotifications.send_notification(question)
  end
end
