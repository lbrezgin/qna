class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_at, :updated_at, :files

  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links
end
