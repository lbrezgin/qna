require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:user_question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }

    before do
      user_question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain')
      other_question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain')
    end

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    # create
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Link }
    it { should be_able_to :create, Reward }
    it { should be_able_to :create, ActiveStorage::Attachment }

    # update
    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other) }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other) }

    it { should be_able_to :update, create(:comment, user: user) }
    it { should_not be_able_to :update, create(:comment, user: other) }

    # destroy
    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other) }

    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer, user: other) }

    it { should be_able_to :destroy, create(:comment, user: user) }
    it { should_not be_able_to :destroy, create(:comment, user: other) }

    it { should be_able_to :destroy, create(:link, linkable: user_question) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_question) }

    it { should be_able_to :destroy, create(:link, linkable: user_question) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_question) }

    it { should be_able_to :destroy, user_question.files[0] }
    it { should_not be_able_to :destroy, other_question.files[0] }

    # mark_as_best
    it { should be_able_to :mark_as_best, create(:answer, question: user_question, user: other)}
    it { should_not be_able_to :mark_as_best, create(:answer, question: other_question, user: other)}

    # voted (like & dislike)
    it { should be_able_to :like, create(:answer, question: user_question, user: other)}
    it { should be_able_to :dislike, create(:answer, question: user_question, user: other)}
    it { should be_able_to :like, create(:question, user: other)}
    it { should be_able_to :dislike, create(:question, user: other)}

    it { should_not be_able_to :like, create(:answer, question: other_question, user: user)}
    it { should_not be_able_to :dislike, create(:answer, question: other_question, user: user)}
    it { should_not be_able_to :like, create(:question, user: user)}
    it { should_not be_able_to :dislike, create(:question, user: user)}
  end
end
