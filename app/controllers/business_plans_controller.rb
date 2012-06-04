class BusinessPlansController < ApplicationController
   before_filter :teacher_user,     only: [:verification]
   before_filter :company_owner, only:[:edit, :update_part, :update, :toggle_visibility]
  
  def edit
    @company = Company.find(params[:id])
    if @company.business_plan.verified?
      flash[:error] = "You cannot edit the business plan once it has been verified"
      redirect_to @company
    end
  end

  def update
    @company = Company.find(params[:id])
    if @company.business_plan.isReady?
      @company.business_plan.waiting = true
      @company.business_plan.save(validate: false)
      redirect_to @company
    else
      flash[:error] = "Fill all the parts first"
      redirect_to edit_business_plan_path(:id => @company.id)
    end
  end

  def show
    @company = Company.find(params[:id])
    if !plan_available?(@company)
      flash[:error] = "This business plan is private"
      redirect_to @company
    end
  end
  
  def update_part
    @company = Company.find(params[:id])
    plan_part = PlanPart.find(params[:part_id])
    plan_part.title = params[:title]
    plan_part.content = params[:content]
    plan_part.save
    redirect_to edit_business_plan_path(:id => @company.id)
  end
  
  def verification
    @company = Company.find(params[:id])
    @company.business_plan.verified = true
    @company.business_plan.waiting = false
    @company.business_plan.save(validate: false)
    redirect_to @company
  end
  
  def toggle_visibility
    @company = Company.find(params[:id])
    @company.business_plan.toggle(:public)
    @company.business_plan.save(validate: false)
    flash[:success] = "Visibility toggled"
    redirect_to @company.business_plan
  end
  
  private
  
  def plan_available?(company)
    if company.business_plan.public?
      true
    else
      if signed_in?
        if current_user.isTeacher?
          true
        elsif current_user.isOwner?(company)
          true
        else
          false
        end
      else
        false
      end
    end
  end
  
end
