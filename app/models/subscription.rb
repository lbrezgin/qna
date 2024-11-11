class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :user_id, uniqueness: { scope: :question_id, message: "already subscribed to this question" }
end
