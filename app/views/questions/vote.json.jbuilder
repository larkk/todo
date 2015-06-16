json.extract! @resource, :id
json.total_votes @resource.total_votes
json.voted @resource.voted_by?(current_user)
json.vote_up_path vote_up_question_path(@resource)
json.vote_down_path vote_down_question_path(@resource)
json.unvote_path unvote_question_path(@resource)
json.user @resource.user, :id, :email
json.current_user_id current_user.id
json.user_signed_in user_signed_in?