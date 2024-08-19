class Answer < ApplicationRecord
  include Linkable
  include Votable

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
  scope :sort_by_best, -> { order(best: :desc) }

  def mark_as_best
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      update(best: true)
      if self.question.reward
        Reward.where(question_id: self.question_id).update_all(user_id: nil)
        self.question.reward.update(user_id: self.user.id)
      end
    end
  end
end

