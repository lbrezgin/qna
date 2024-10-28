class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :user_id, :best, :created_at, :updated_at

  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links
end
