class AnswerCollectionSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :user_id, :best, :created_at, :updated_at
end
