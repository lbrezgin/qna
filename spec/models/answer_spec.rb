require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'linkable'

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  it { should have_many_attached(:files) }

  let!(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answers) { create_list(:answer, 5, question: question, user: author) }
  let!(:best_answer) { create(:answer, question: question, user: author, best: true) }
  let!(:reward) { create(:reward,
                          image: fixture_file_upload("#{Rails.root}/app/assets/images/test_reward.png"),
                          question: question) }
  describe '.sort_by_best' do
    it 'sorts the answers by best' do
      sorted_answers = question.answers.sort_by_best
      expect(sorted_answers.first).to eq best_answer
      expect(sorted_answers.size).to eq question.answers.size
    end
  end

  describe '.mark_as_best' do
    it 'should mark only the one answer as best and assign an reward' do
      answers.first.mark_as_best

      expect(answers.first.best).to eq true
      expect(question.answers.where(best: true).count).to eq 1
      expect(answers.first.user.rewards[0]).to eq reward
    end
  end
end
