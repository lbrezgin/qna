require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  let!(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answers) { create_list(:answer, 5, question: question, user: author) }
  let!(:best_answer) { create(:answer, question: question, user: author, best: true) }

  describe '.sort_by_best' do
    it 'sorts the answers by best' do
      sorted_answers = question.answers.sort_by_best
      expect(sorted_answers.first).to eq best_answer
      expect(sorted_answers.size).to eq question.answers.size
    end
  end

  describe '.mark_as_best' do
    it 'should mark only the one answer as best' do
      answers.first.mark_as_best
      expect(answers.first.best).to eq true
      expect(question.answers.where(best: true).count).to eq 1
    end
  end
end
