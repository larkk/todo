# Preview all emails at http://localhost:3000/rails/mailers/author_mailer
class AuthorMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/author_mailer/new_answer
  def new_answer
    AuthorMailer.new_answer
  end

end
