class Notification
  def self.send_notification(question)
    subscriptions = Subscription.where(question: question)

    if subscriptions
      subscriptions.each do |sub|
        NotificationMailer.notify(sub.user, question.title).deliver_later
      end
    end
  end
end
