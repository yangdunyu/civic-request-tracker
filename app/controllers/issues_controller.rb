class IssuesController < ApplicationController
  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new(issue_params)

    if @issue.save
      redirect_to issue_path(@issue), notice: "Thanks. Your request has been submitted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @issue = Issue.find(params[:id])
  end

  private

  def issue_params
    params.require(:issue).permit(:title, :description, :category, :location, :contact_email, :image)
  end
end
