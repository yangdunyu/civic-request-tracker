class Issue < ApplicationRecord
  CATEGORIES = {
    roads: 0,
    waste: 1,
    public_facilities: 2,
    noise: 3,
    other: 4,
    public_safety: 5
  }.freeze

  belongs_to :assigned_to, class_name: "User", optional: true, inverse_of: :assigned_issues
  has_many :comments, dependent: :destroy
  has_one_attached :image

  enum :category, CATEGORIES
  enum :status, { new_request: 0, triage: 1, in_progress: 2, resolved: 3 }
  enum :priority, { low: 0, medium: 1, high: 2 }

  validates :title, :description, :category, :status, :priority, :location, :contact_email, presence: true
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :assigned_to_must_be_admin

  before_validation :apply_ai_triage, on: :create

  scope :search, ->(query) {
    return all if query.blank?

    where("title ILIKE :query OR description ILIKE :query", query: "%#{sanitize_sql_like(query)}%")
  }

  def status_label
    {
      "new_request" => "New",
      "triage" => "Triage",
      "in_progress" => "In Progress",
      "resolved" => "Resolved"
    }.fetch(status, status.to_s.humanize)
  end

  def category_label
    category.to_s.humanize.titleize
  end

  private

  def apply_ai_triage
    result = AiTriageService.new(description: description.to_s, title: title.to_s).call
    self.ai_summary = result.summary
    self.ai_suggested_category = result.suggested_category
    self.category = result.category if category.blank? || category == "other"
    self.priority = result.priority if priority.blank? || priority == "medium"
  rescue AiTriageService::Error
    self.ai_summary ||= "AI triage unavailable. Review manually."
    self.ai_suggested_category ||= "Manual review required"
  end

  def assigned_to_must_be_admin
    return if assigned_to.blank? || assigned_to.admin?

    errors.add(:assigned_to, "must be an admin user")
  end
end
