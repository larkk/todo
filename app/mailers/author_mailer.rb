class AuthorMailer < ApplicationMailer
  def new_answer(user, answer)
    @answer = answer
    mail to: user.email
  end
end
