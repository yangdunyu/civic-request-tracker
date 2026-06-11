require "rails_helper"

RSpec.describe User, type: :model do
  it "defaults to citizen role" do
    user = described_class.new(email: "citizen@example.com", password: "password123")

    expect(user).to be_citizen
  end
end
