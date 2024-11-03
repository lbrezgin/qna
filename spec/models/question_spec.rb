require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it {should have_many(:answers).dependent(:destroy) }
  it {should have_one(:reward).dependent(:destroy) }

  it {should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :reward  }

  it { should have_many_attached(:files) }
end
