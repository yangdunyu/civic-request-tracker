require "rails_helper"

RSpec.describe IssueMailer, type: :mailer do
  describe "status_updated" do
    it "renders the latest status" do
      issue = Issue.create!(
        title: "Pothole",
        description: "A pothole opened on the main road.",
        category: :roads,
        status: :in_progress,
        location: "Main Road",
        contact_email: "resident@example.com"
      )

      mail = described_class.status_updated(issue)

      expect(mail.subject).to eq("Your civic request has been updated")
      expect(mail.to).to eq(["resident@example.com"])
      expect(mail.from).to eq(["notifications@civicflow.local"])
      expect(mail.body.encoded).to include("In Progress")
    end
  end
end
