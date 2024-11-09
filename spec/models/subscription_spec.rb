require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it 'validates uniqueness of user_id scoped to question_id' do
    create(:subscription, user: user, question: question)

    subscription = build(:subscription, user: user, question: question)

    expect(subscription).not_to be_valid
    expect(subscription.errors[:user_id]).to include('already subscribed to this question')
  end
end
