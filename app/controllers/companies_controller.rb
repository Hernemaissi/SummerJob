class CompaniesController < ApplicationController
  before_filter :teacher_user,     only: [:new]
  before_filter :company_owner,   only: [:mail, :edit, :update]
  before_filter :company_already_init, only: [:init, :update_init]
  before_filter :redirect_if_not_signed, only: [:show]
  before_filter :signed_in_user, except: [:index, :show]
  before_filter :has_company, except: [:index, :show]
  
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
    @company.assign_attributes(params[:company])
    @company.get_extra_cost
    @company.values_decided = true
    @company.calculate_costs
    @company.calculate_mitigation_cost
    @company.calculate_max_capacity
    can_change = @company.can_change_business_model
    contract_ok = true
    if params[:contract]
      contract = Contract.find(params[:contract][:id])
      contract_ok = Contract.valid_actual_launches(@company, params[:contract][:actual_launches])
      contract.update_attribute(:actual_launches, params[:contract][:actual_launches]) if contract_ok
    end
    if @company.save && contract_ok
      flash[:success] = "Successfully updated company information"
      redirect_to @company
    else
      @company = Company.find(params[:id])
      @stat_hash = @company.get_stat_hash(1,1, 0, 0, 0, 0, 0)
      flash.now[:error] = "You cannot change business model (service level or product type) if you have already made a contract with someone" unless can_change
      flash.now[:error] = "Total amount of launches provided for companies has to between 0 and #{@company.max_capacity}" unless contract_ok
      render 'edit'
    end
  end
  
  def init
    @company = Company.find(params[:id])
    @stat_hash = @company.get_stat_hash(1,1, 0, 0, 0, 0, 0)
  end

  def update_init
    @company = Company.find(params[:id])
    @company.name = params[:name]
    @company.about_us = params[:about_us]
    if @company.save
      flash[:success] = "Successfully updated company information"
      @company.initialised = true
      @company.save(valitedate: false)
      redirect_to @company
    else
     @company = Company.find(params[:id])
      render 'init'
    end
  end
  
  def get_stats
    @company = Company.find(Integer(params[:id]))
    level =  Integer(params[:level])
    type =  Integer(params[:type])
    risk_mit = Float(params[:risk_cost]).to_i
    capacity_cost = Float(params[:capacity_cost]).to_i
    variable_cost = Float(params[:variable_cost]).to_i
    sell_price = Integer(params[:sell_price])
    market_id = Integer(params[:market_id])
    @stat_hash = @company.get_stat_hash(level, type, risk_mit, capacity_cost, variable_cost, sell_price, market_id)
    respond_to do |format| 
      format.js
    end
  end

  def get_costs
    @company = Company.find(Integer(params[:id]))
    level =  Integer(params[:level])
    type =  Integer(params[:type])
    @fixed_base = @company.calculate_fixed_cost(level, type, @company)
    @max_base = @company.calculate_fixed_limit(level, type, @company)
    @var_limit = Company.calculate_variable_limit(level, type, @company)
    @var_min = Company.calculate_variable_min(level, type, @company)
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
    sell_price = @company.is_customer_facing? ? @company.role.sell_price : 0;
    market_id = @company.is_customer_facing? ? @company.role.market_id : 0;
    @stat_hash = @company.get_stat_hash(@company.role.service_level,@company.role.product_type, @company.risk_mitigation, @company.capacity_cost, @company.variable_cost, sell_price, market_id)
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

  def redirect_if_not_signed
    @company = Company.find(params[:id])
    unless signed_in?
      redirect_to show_company_profile_path(@company)
    end
  end
  
end
