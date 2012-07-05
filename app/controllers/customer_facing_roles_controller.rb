class CustomerFacingRolesController < ApplicationController

  before_filter :role_owner, only: [:edit, :update]

  def index
    @customerfacing_companies = CustomerFacingRole.all
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    @customer_facing_role = CustomerFacingRole.find(params[:id])
  end

  def update
    @customer_facing_role = CustomerFacingRole.find(params[:id])
    @customer_facing_role.update_attributes(params[:customer_facing_role])
    if @customer_facing_role.save
      flash[:success] = "Succesfully updated choices"
      redirect_to @customer_facing_role.company
    else
      render 'edit'
    end
  end

  private

  def role_owner
       @customer_facing_role = CustomerFacingRole.find(params[:id])
      if !signed_in? || !current_user.group || !current_user.group.company || !(current_user.group.company.role == @customer_facing_role)
        unless signed_in? && current_user.isTeacher?
          flash[:error] = "You are not allowed to view this page"
          redirect_to(root_path)
        end
      end
    end

end
