require "rails_helper"

RSpec.describe "Admin comments", type: :request do
  it "allows admins to add internal notes" do
    admin = User.create!(email: "comments-admin@example.com", password: "password123", role: :admin)
    issue = Issue.create!(
      title: "Street light out",
      description: "The street light outside the library is out.",
      category: :public_facilities,
      location: "Library",
      contact_email: "resident@example.com"
    )

    sign_in admin

    expect {
      post admin_comments_path, params: { comment: { issue_id: issue.id, body: "Assigned to facilities team." } }
    }.to change(Comment, :count).by(1)

    comment = Comment.last
    expect(comment).to be_internal
    expect(comment.user).to eq(admin)
    expect(response).to redirect_to(admin_issue_path(issue))
  end
end
