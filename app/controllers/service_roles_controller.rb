class ServiceRolesController < ApplicationController

  def index
    @service_companies = ServiceRole.where("service_type = ?", params[:service_type])
    @company_title = params[:service_type]
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    @service_role = ServiceRole.find(params[:id])
  end

  def update
    @sr = ServiceRole.find(params[:id])
    level_changed = false
    if @sr.service_level != params[:service_role][:service_level].to_i
      level_changed = true
    end
    @sr.update_attributes(params[:service_role])
    if @sr.save
      flash[:success] = "Succesfully updated changes"
      if level_changed
        @sr.company.network.total_profit -= 10000
        @sr.company.network.score -= 10000
        @sr.company.network.save!
      end
      redirect_to @sr.company
    else
      render 'edit'
    end
  end
end
