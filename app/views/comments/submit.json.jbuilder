json.extract! @comment, :id, :body, :commentable_type, :commentable_id
json.user @comment.user, :id, :email
json.current_user_id current_user.id
json.user_signed_in user_signed_in?