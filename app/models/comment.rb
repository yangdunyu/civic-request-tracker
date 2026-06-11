class Comment < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  validates :body, presence: true
  validate :user_must_be_admin

  private

  def user_must_be_admin
    return if user&.admin?

    errors.add(:user, "must be an admin user")
  end
end
