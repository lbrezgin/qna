class NotificationMailer < ApplicationMailer
  def notify(user, title)
    @title = title

    mail to: user.email
  end
end
