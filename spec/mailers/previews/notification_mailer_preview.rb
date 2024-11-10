# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  # Preview this email at at http://localhost:3000/rails/mailers/notification_mailer/notify

  def notify
    user = FactoryBot.build(:user)
    title = FactoryBot.build(:question).title

    NotificationMailer.notify(user, title)
  end
end
