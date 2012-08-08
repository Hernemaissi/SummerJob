class CompanyProfilesController < ApplicationController

  def edit
    @company = Company.find(params[:id])
  end

  def update
    cur = current_user
    current_user.update_attribute(:description, params[:description])
    sign_in cur
    @company  = Company.find(params[:id])
    @company.update_attribute(:about_us, params[:about_us])
    @company.update_attribute(:for_investors, params[:for_investors])
    flash[:success] = "Updated data succesfully"
    redirect_to show_company_profile_path(@company)
  end

  def show
    @company = Company.find(params[:id])
  end
end
