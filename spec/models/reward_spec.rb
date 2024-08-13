require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional }
  it { should have_one_attached(:image) }

  it { should validate_presence_of :title }

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  describe '.image_presence_if_title_present' do
    it 'should validate presence of image' do
      reward = question.build_reward(title: 'test title')
      question.valid?
      expect(question.errors.full_messages[0]).to eq "Reward image must be attached if title is present"
    end
  end
end
