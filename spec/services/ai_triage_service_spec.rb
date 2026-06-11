require "rails_helper"

RSpec.describe AiTriageService do
  it "classifies public safety hazards as high priority" do
    result = described_class.new(description: "There is broken glass near the school bus stop.").call

    expect(result.suggested_category).to eq("Public Safety")
    expect(result.priority).to eq("high")
  end
end
