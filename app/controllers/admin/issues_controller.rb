class Admin::IssuesController < Admin::BaseController
  def index
    @statuses = Issue.statuses.keys
    @categories = Issue.categories.keys
    @issues = filtered_issues
    @issues_by_status = @issues.includes(:assigned_to).group_by(&:status)
  end

  def show
    @issue = Issue.includes(:comments).find(params[:id])
    authorize @issue
    @comment = Comment.new
    @admins = User.admin.order(:email)
  end

  def update
    @issue = Issue.find(params[:id])
    authorize @issue
    old_status = @issue.status

    if @issue.update(issue_params)
      IssueMailer.status_updated(@issue).deliver_later if @issue.status != old_status
      redirect_to admin_issue_path(@issue), notice: "Request updated."
    else
      @comment = Comment.new
      @admins = User.admin.order(:email)
      render :show, status: :unprocessable_entity
    end
  end

  private

  def filtered_issues
    Issue
      .search(params[:query])
      .then { |scope| params[:status].present? ? scope.where(status: params[:status]) : scope }
      .then { |scope| params[:category].present? ? scope.where(category: params[:category]) : scope }
      .order(created_at: :desc)
  end

  def issue_params
    params.require(:issue).permit(:status, :category, :priority, :assigned_to_id)
  end
end
