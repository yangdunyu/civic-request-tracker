require "rails_helper"

RSpec.describe "Admin issues", type: :request do
  let(:admin) { User.create!(email: "issues-admin@example.com", password: "password123", role: :admin) }
  let(:citizen) { User.create!(email: "issues-citizen@example.com", password: "password123", role: :citizen) }
  let!(:issue) do
    Issue.create!(
      title: "Broken glass",
      description: "There is broken glass near the school bus stop.",
      category: :other,
      location: "Main Road",
      contact_email: "resident@example.com"
    )
  end

  it "blocks citizens from the admin dashboard" do
    sign_in citizen

    get admin_issues_path

    expect(response).to redirect_to(root_path)
  end

  it "shows dashboard filters to admins" do
    sign_in admin

    get admin_issues_path, params: { query: "glass", status: "new_request" }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Broken glass")
  end

  it "updates status and sends an email" do
    sign_in admin

    expect {
      patch admin_issue_path(issue), params: {
        issue: {
          status: "in_progress",
          category: "public_safety",
          priority: "high",
          assigned_to_id: admin.id
        }
      }
      perform_enqueued_jobs
    }.to change(ActionMailer::Base.deliveries, :count).by(1)

    issue.reload
    expect(issue.status).to eq("in_progress")
    expect(issue.assigned_to).to eq(admin)
    expect(ActionMailer::Base.deliveries.last.body.encoded).to include("In Progress")
  end

  it "does not email when status is unchanged" do
    sign_in admin

    expect {
      patch admin_issue_path(issue), params: {
        issue: {
          status: issue.status,
          category: "roads",
          priority: "medium"
        }
      }
      perform_enqueued_jobs
    }.not_to change(ActionMailer::Base.deliveries, :count)
  end
end
