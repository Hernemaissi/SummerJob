class RevisionsController < ApplicationController
  before_filter :plan_is_public?
  def show
    @revision = Revision.find(params[:id])
  end

  private

  def plan_is_public?
    @revision = Revision.find(params[:id])
    unless (signed_in? && current_user.isOwner?(@revision.company)) || @revision.company.business_plan.public?
      flash[:error] = "This company has not set their plan as public, so you cannot view it"
      redirect_to @revision.company
    end
  end
end
