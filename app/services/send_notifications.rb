class SendNotifications
  def self.send_notification(question)
    subscriptions = Subscription.where(question: question)

    subscriptions.each do |sub|
      NotificationMailer.notify(sub.user, question.title).deliver_later
    end
  end
end
