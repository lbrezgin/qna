require 'sphinx_helper'

RSpec.describe SearchForResource do
  let!(:question_one) { create(:question, title: 'new Ruby question') }
  let!(:question_two) { create(:question, title: 'Ruby or Python?') }
  let!(:answer) { create(:answer, body: 'Ruby the best') }
  let!(:comment) { create(:comment, content: 'I agree, Ruby the best') }
  let!(:user) { create(:user) }

  before do
    ThinkingSphinx::Test.index
  end

  it 'returns array with specific resource', sphinx: true do
    ThinkingSphinx::Test.run do
      result = SearchForResource.search_for(user.email, 'User')
      expect(result.first.id).to eq user.id
    end
  end

  it 'returns array of resources', sphinx: true do
    ThinkingSphinx::Test.run do
      result = SearchForResource.search_for('Ruby', 'All')
      expect(result[0].id).to eq question_one.id
      expect(result[1].id).to eq question_two.id
      expect(result[2].id).to eq answer.id
      expect(result[3].id).to eq comment.id
    end
  end
end
