# Preview all emails at http://localhost:3000/rails/mailers/daily_digest_mailer
class DailyDigestMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/daily_digest_mailer/digest
  def digest
    user = FactoryBot.build(:user)
    titles = FactoryBot.build_list(:question, 2).map(&:title)

    DailyDigestMailer.digest(user, titles)
  end
end
