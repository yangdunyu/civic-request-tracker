require "rails_helper"

RSpec.describe Issue, type: :model do
  it "requires public submission fields" do
    issue = described_class.new

    expect(issue).not_to be_valid
    expect(issue.errors[:title]).to be_present
    expect(issue.errors[:description]).to be_present
    expect(issue.errors[:location]).to be_present
    expect(issue.errors[:contact_email]).to be_present
  end

  it "generates AI triage on create" do
    issue = described_class.create!(
      title: "Broken glass",
      description: "There is broken glass near the school bus stop.",
      category: :other,
      location: "Main Road",
      contact_email: "resident@example.com"
    )

    expect(issue.ai_summary).to include("Safety hazard")
    expect(issue.ai_suggested_category).to eq("Public Safety")
    expect(issue.category).to eq("public_safety")
    expect(issue.priority).to eq("high")
  end

  it "does not allow assignment to a citizen" do
    citizen = User.create!(email: "issue-citizen@example.com", password: "password123", role: :citizen)
    issue = described_class.new(
      title: "Road problem",
      description: "A pothole is forming.",
      category: :roads,
      location: "Queen Street",
      contact_email: "resident@example.com",
      assigned_to: citizen
    )

    expect(issue).not_to be_valid
    expect(issue.errors[:assigned_to]).to include("must be an admin user")
  end
end
