module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def make_vote(user, type)
    existing_vote = self.votes.find_by(user: user, votable: self)

    if existing_vote.nil?
      self.votes.create(user: user, vote_type: type, votable: self)
    elsif existing_vote.vote_type == type
      existing_vote.destroy
    else
      existing_vote.destroy
      self.votes.create(user: user, vote_type: type, votable: self)
    end
  end

  def rating
    likes = self.votes.where(vote_type: 'like').count
    dislikes = self.votes.where(vote_type: 'dislike').count
    likes - dislikes
  end
end

