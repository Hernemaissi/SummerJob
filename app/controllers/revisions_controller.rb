class RevisionsController < ApplicationController
  before_filter :plan_is_public?
  def show
    @revision = Revision.find(params[:id])
  end

  def update
    @revision = Revision.find(params[:id])
    @revision.update_attributes(params[:revision])
    if @revision.save
      flash[:success] = "Revision graded succesfully"
      redirect_to @revision
    else
      flash[:error] = "Grading failed, please try again"
      redirect_to @revision
    end
  end

  private

  def plan_is_public?
    @revision = Revision.find(params[:id])
    unless (signed_in? && current_user.isOwner?(@revision.company)) || @revision.company.business_plan.public?
      flash[:error] = "This company has not set their plan as public"
      redirect_to @revision.company
    end
  end
end
