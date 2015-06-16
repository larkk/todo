json.extract! @question, :id, :title, :body
json.user @question.user, :id, :email
json.current_user_id current_user.id
json.user_signed_in user_signed_in?
json.path question_path(@question)

json.attachments @question.attachments do |a|
  json.id a.id
  json.file_name a.file.identifier
  json.file_url a.file.url
  json.path attachment_path(a)
end
