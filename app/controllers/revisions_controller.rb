class RevisionsController < ApplicationController
  before_filter :plan_is_public?, only: [:show]
  before_filter :teacher_user, only: [:update]
  def show
    @revision = Revision.find(params[:id])
    @revision.update_attribute(:read, true) if signed_in? && !current_user.teacher && current_user.isOwner?(@revision.company)
  end

  def update
    @revision = Revision.find(params[:id])
    @revision.update_attributes(params[:revision])
    if @revision.save
      flash[:success] = "Revision graded succesfully"
      @revision.company.business_plan.update_attribute(:grade, @revision.grade)
      @revision.company.bonus_capital_from_business_plan(@revision.grade)
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
