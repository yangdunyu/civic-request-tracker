# Preview all emails at http://localhost:3000/rails/mailers/issue_mailer_mailer
class IssueMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/issue_mailer_mailer/status_updated
  def status_updated
    IssueMailer.status_updated
  end

end
