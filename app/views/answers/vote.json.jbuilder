json.extract! @resource, :id, :question_id
json.total_votes @resource.total_votes
json.voted @resource.voted_by?(current_user)
json.vote_down_path vote_down_answer_path(@resource)
json.vote_up_path vote_up_answer_path(@resource)
json.unvote_path unvote_answer_path(@resource)
json.user @resource.user, :id, :email
json.current_user_id current_user.id
json.user_signed_in user_signed_in?