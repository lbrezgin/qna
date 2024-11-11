require 'rails_helper'

RSpec.describe SendNotifications do
  let!(:question) { create(:question) }

  describe 'subscriptions exist' do
    let!(:users) { create_list(:user, 2) }
    let!(:subscription_one) { create(:subscription, question: question, user: users.first) }
    let!(:subscription_second) { create(:subscription, question: question, user: users.second) }

    it 'sends notifications about new answer' do
      users.each { |user| expect(NotificationMailer).to receive(:notify).with(user, question.title).and_call_original }
      SendNotifications.send_notification(question)
    end
  end

  describe 'subscriptions does not exist' do
    it 'no error if no subscriptions exist' do
      expect(NotificationMailer).to_not receive(:notify)
      SendNotifications.send_notification(question)
    end
  end
end
