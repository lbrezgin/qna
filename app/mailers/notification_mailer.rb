class NotificationMailer < ApplicationMailer
  def notify(user, question)
    @question = question

    mail to: user.email
  end
end
