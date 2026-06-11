class ApplicationMailer < ActionMailer::Base
  default from: "notifications@civicflow.local"
  layout "mailer"
end
