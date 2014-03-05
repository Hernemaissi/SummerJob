class CompanyTypesController < ApplicationController
  before_filter :teacher_user

  def new
    @company_type = CompanyType.new
  end

  def create
    company_type = CompanyType.new(params[:company_type])
    if company_type.save
      flash[:success] = "New company type created successfully"
      redirect_to company_types_url
    else
      render new
    end
  end

  def show
  end

  def index
    @types = CompanyType.order("id").all
  end

  def edit
    @company_type = CompanyType.find(params[:id])
  end

  def update
    company_type = CompanyType.find(params[:id])
    company_type.update_attributes(params[:company_type])
    if company_type.save
      flash[:success] = "Company type updated successfully"
      redirect_to company_types_url
    else
      render edit
    end
  end

  def destroy
    CompanyType.find(params[:id]).destroy
    flash[:success] = "Company type destroyed."
    redirect_to company_types_path
  end


end
