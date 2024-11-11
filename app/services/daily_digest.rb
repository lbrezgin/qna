class DailyDigest
  def send_digest
    titles = Question.where("created_at >= ?", 1.day.ago).map(&:title)

    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, titles).deliver_later
    end
  end
end
