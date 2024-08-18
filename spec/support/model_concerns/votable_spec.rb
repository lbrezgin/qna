require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let!(:resource) { create(described_class.name.underscore.to_sym) }
  let!(:seven_users) { create_list :user, 7 }
  let!(:five_users) { create_list :user, 5 }

  describe '.make_vote' do
    it 'create a like vote' do
      resource.make_vote(seven_users[0], 'like')
      resource.reload

      expect(resource.votes.count).to eq 1
    end

    it 'create a dislike vote and destroy previous' do
      resource.make_vote(seven_users[0], 'like')
      resource.make_vote(seven_users[0], 'dislike')
      resource.reload

      expect(resource.votes.count).to eq 1
      expect(resource.votes[0].vote_type).to eq 'dislike'
    end

    it 'destroy dislike vote, voting again' do
      resource.make_vote(seven_users[0], 'like')
      resource.make_vote(seven_users[0], 'dislike')
      resource.make_vote(seven_users[0], 'dislike')
      resource.reload

      expect(resource.votes.count).to eq 0
    end
  end

  describe '.rating' do
    before do
      seven_users.each do |user|
        resource.make_vote(user, 'like')
      end

      five_users.each do |user|
        resource.make_vote(user, 'dislike')
      end
    end

    it 'return vote rating' do
      expect(resource.rating).to eq 2
    end
  end
end
