require 'rails_helper'

RSpec.describe DailyDigest do
  let!(:questions) { create_list(:question, 3) }
  let!(:questions_titles) { questions.map(&:title) }

  it 'sends daily digest to all users' do
    User.all.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions_titles).and_call_original }
    subject.send_digest
  end
end
