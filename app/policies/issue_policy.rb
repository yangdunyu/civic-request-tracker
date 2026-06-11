class IssuePolicy
  attr_reader :user, :issue

  def initialize(user, issue)
    @user = user
    @issue = issue
  end

  def show?
    user&.admin?
  end

  def update?
    user&.admin?
  end
end
