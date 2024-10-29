class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :commentable_type, :commentable_id, :user_id, :created_at, :updated_at
end
