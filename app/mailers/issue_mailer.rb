class IssueMailer < ApplicationMailer
  def status_updated(issue)
    @issue = issue

    mail to: @issue.contact_email, subject: "Your civic request has been updated"
  end
end
