class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id, :commentable_id, :commentable_type
end