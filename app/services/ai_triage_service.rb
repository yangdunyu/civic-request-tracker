class AiTriageService
  Result = Data.define(:summary, :suggested_category, :category, :priority)
  Error = Class.new(StandardError)

  def initialize(description:, title: "")
    @text = [title, description].join(" ").downcase
    @description = description.to_s.strip
  end

  def call
    raise Error, "No content to triage" if @text.blank?

    if public_safety?
      Result.new(
        summary: concise_summary("Safety hazard reported"),
        suggested_category: "Public Safety",
        category: "public_safety",
        priority: "high"
      )
    elsif road?
      Result.new(summary: concise_summary("Road issue reported"), suggested_category: "Roads", category: "roads", priority: "medium")
    elsif waste?
      Result.new(summary: concise_summary("Waste issue reported"), suggested_category: "Waste", category: "waste", priority: "medium")
    elsif noise?
      Result.new(summary: concise_summary("Noise issue reported"), suggested_category: "Noise", category: "noise", priority: "low")
    else
      Result.new(summary: concise_summary("Service issue reported"), suggested_category: "Other", category: "other", priority: "medium")
    end
  end

  private

  def concise_summary(prefix)
    first_sentence = @description.split(/[.!?]/).first.to_s.strip
    detail = first_sentence.presence || "Citizen submitted a service request"
    "#{prefix}: #{detail.truncate(140)}."
  end

  def public_safety?
    @text.match?(/broken glass|danger|unsafe|injur|school|hazard/)
  end

  def road?
    @text.match?(/road|pothole|street|footpath|traffic|sign/)
  end

  def waste?
    @text.match?(/rubbish|trash|garbage|bin|waste|dump/)
  end

  def noise?
    @text.match?(/noise|loud|music|party/)
  end
end
