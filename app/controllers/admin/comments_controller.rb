class Admin::CommentsController < Admin::BaseController
  def create
    issue = Issue.find(params[:comment][:issue_id])
    comment = issue.comments.build(comment_params.merge(user: current_user, internal: true))

    if comment.save
      redirect_to admin_issue_path(issue), notice: "Internal note added."
    else
      redirect_to admin_issue_path(issue), alert: comment.errors.full_messages.to_sentence
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:issue_id, :body)
  end
end
