class BusinessPlansController < ApplicationController
   before_filter :teacher_user,     only: [:verification]
   before_filter :company_owner, only:[:edit, :update_part, :update, :toggle_visibility]
   before_filter :in_round_one, only:[:edit, :update, :update_part]
   before_filter :correct_position, only: [:update_part]
   before_filter :signed_in_user
   before_filter :positions_set, only: [:edit, :update]
  
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
      @company.business_plan.submit_date = DateTime.now
      @company.business_plan.save(validate: false)
      redirect_to @company.business_plan
    else
      flash[:error] = "Fill all the parts first"
      redirect_to edit_business_plan_path(:id => @company.id)
    end
  end

  def show
    @company = Company.find(params[:id])
  end
  
  def update_part
    @company = Company.find(params[:id])
    @plan_part.title = params[:title]
    @plan_part.content = params[:content]
    @plan_part.save
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
  
  def correct_position
    @plan_part = PlanPart.find(params[:part_id])
    unless @plan_part.position == current_user.position || @plan_part.anybody?
      flash[:error] = "You are not allowed to update this part"
      redirect_to edit_business_plan_path(@plan_part.business_plan)
    end
  end

  def positions_set
    unless current_user.teacher? || current_user.group.all_users_have_positions
      flash[:error] = "You cannot edit the business plan until all members of the group have selected their positions"
      redirect_to current_user.company
    end
  end
  
end
