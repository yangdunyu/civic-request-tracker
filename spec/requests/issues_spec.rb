require "rails_helper"

RSpec.describe "Issues", type: :request do
  it "allows a citizen to submit a request" do
    expect {
      post issues_path, params: {
        issue: {
          title: "Broken glass near school",
          description: "There is broken glass near the school bus stop.",
          category: "other",
          location: "Main Road",
          contact_email: "resident@example.com"
        }
      }
    }.to change(Issue, :count).by(1)

    issue = Issue.last
    expect(response).to redirect_to(issue_path(issue))
    expect(issue.status).to eq("new_request")
    expect(issue.ai_summary).to be_present
  end

  it "rejects invalid email addresses" do
    post issues_path, params: {
      issue: {
        title: "Overflowing bin",
        description: "The bin is overflowing.",
        category: "waste",
        location: "Library",
        contact_email: "not-an-email"
      }
    }

    expect(response).to have_http_status(422)
    expect(Issue.count).to eq(0)
  end
end
