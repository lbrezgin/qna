require 'rails_helper'

RSpec.describe DailyDigest do
  let!(:users) { create_list(:user, 5) }
  let!(:questions) { create_list(:question, 3, user: users.first) }
  let!(:titles) { questions.map(&:title) }

  it 'sends daily digest to all users' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, titles).and_call_original }
    subject.send_digest
  end
end
