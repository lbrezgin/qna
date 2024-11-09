require 'rails_helper'

RSpec.describe Notification do
  let!(:question) { create(:question) }
  let!(:users) { create_list(:user, 2) }
  let!(:subscription_one) { create(:subscription, question: question, user: users.first) }
  let!(:subscription_second) { create(:subscription, question: question, user: users.second) }

  it 'sends notifications about new answer' do
    users.each { |user| expect(NotificationMailer).to receive(:notify).with(user, question.title).and_call_original }
    Notification.send_notification(question)
  end
end
