require "rails_helper"

RSpec.describe Comment, type: :model do
  it "requires an admin author" do
    citizen = User.create!(email: "comment-citizen@example.com", password: "password123", role: :citizen)
    issue = Issue.create!(
      title: "Noise issue",
      description: "Loud music every night.",
      category: :noise,
      location: "Harbour Street",
      contact_email: "resident@example.com"
    )

    comment = described_class.new(issue:, user: citizen, body: "Review later")

    expect(comment).not_to be_valid
    expect(comment.errors[:user]).to include("must be an admin user")
  end
end
