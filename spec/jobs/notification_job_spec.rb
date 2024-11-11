require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let!(:question) { create(:question) }

  it 'calls SendNotifications#notify' do
    expect(SendNotifications).to receive(:send_notification).with(question)
    NotificationJob.perform_now(question)
  end
end
