class NeedsController < ApplicationController
  before_filter :teacher_user
  
  def create
    @company = Company.find(params[:id])
    other_company = Company.find(params[:other_id])
    @company.need!(other_company)
    redirect_to need_path(@company.id)
  end

  def destroy
    @company = Company.find(params[:id])
    other_company = Company.find(params[:other_id])
    @company.remove_need!(other_company)
    redirect_to need_path(@company.id)
  end

  def show
    @company = Company.find(params[:id])
    @companies = Company.all
  end
end
