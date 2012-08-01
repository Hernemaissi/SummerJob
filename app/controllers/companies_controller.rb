class CompaniesController < ApplicationController
  before_filter :teacher_user,     only: [:new]
  before_filter :company_owner,   only: [:mail]
  before_filter :company_already_init, only: [:update, :init]
  before_filter :signed_in_user
  before_filter :has_company
  
  def new
    @company = Company.new
    groups = Group.all
    @free_groups = Group.free(groups)
  end

  def create
    @group = Group.find_by_id(params[:group][:id])
    if !@group
      flash.now[:error] = "Please specify a owner"
      @company = Company.new(params[:company])
      groups = Group.all
      @free_groups = Group.free(groups)
      render 'new'
    else
      @company = @group.create_company(params[:company])
      @company.name = "Company #{@group.id} "
      @company.create_role
      if @company.save
        flash[:success] = "Created a new company"
        redirect_to companies_path
      else
        groups = Group.all
        @free_groups = Group.free(groups)
        render 'new'
      end
    end
  end

  def show
    @company = Company.find(params[:id])
    if !@company.initialised?
      if signed_in? && current_user.isOwner?(@company) && !current_user.teacher?
        flash[:notice] = "Please fill some basic information about your company"
        redirect_to init_path(:id => @company.id)
      else
        flash[:error] = "Company has not been founded yet"
        redirect_to companies_path
       end
     end
   end

  def index
    @companies = Company.all
    @tech_companies = ServiceRole.where("service_type = 'Technology'")
    @supply_companies = ServiceRole.where("service_type = 'Supplier'")
    @operator_companies = OperatorRole.all
    @customer_companies = CustomerFacingRole.all
      respond_to do |format|
        format.js
        format.html
      end
  end
  
  def update
    @company = Company.find(params[:id])
    @company.update_attributes(params[:company])
    @company.calculate_costs
    if @company.save
      flash[:success] = "Successfully updated company information"
      @company.initialised = true
      @company.save(valitedate: false)
      redirect_to @company
    else
      render 'init'
    end
  end
  
  def init
    @company = Company.find(params[:id])
    @stat_hash = @company.get_stat_hash(1,1,1, false)
  end
  
  def get_stats
    level =  Integer(params[:level])
    specialized = (params[:specialized] == "true") ? true : false
    capacity =  Integer(params[:capacity])
    type =  Integer(params[:type])
    @stat_hash = current_user.company.get_stat_hash(level, capacity, type, specialized)
    respond_to do |format| 
      format.js
    end
  end
  
  def mail
    @company = Company.find(params[:id])
  end
  
  def search
    @companies = Company.search(params[:field], params[:query])
    respond_to do |format|
      format.js
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update_about_us
    @company = Company.find(params[:id])
    @company.about_us = params[:about_us]
    if @company.save
      flash[:success] = "Updated company information"
      redirect_to @company
    else
      render 'edit'
    end
  end

  private

  def company_already_init
      @company = Company.find(params[:id])
      if @company.initialised?
        flash[:error] = "This company has already been founded"
        redirect_to @company
      end
  end
  
end
