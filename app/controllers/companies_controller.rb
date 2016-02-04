class CompaniesController < ApplicationController
  before_filter :teacher_user,     only: [:new, :text_data]
  before_filter :company_owner,   only: [:mail, :edit, :update, :results, :expand, :expand_update]
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
      @company = @group.create_company()
      @company.company_type_id = params[:company][:company_type_id].to_i
      @company.name = "Company #{@group.id}"
      @company.set_starting_capital
      if @company.save
        flash[:success] = "Created a new company"
        @company.set_role
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
    if signed_in? && current_user.isOwner?(@company)
      if !@company.initialised?
        if signed_in? && current_user.isOwner?(@company) && !current_user.teacher?
          flash[:notice] = "Please fill some basic information about your company"
          redirect_to init_path(:id => @company.id)
        else
          flash[:error] = "Company has not been founded yet"
          redirect_to companies_path
        end
      end
    else
      redirect_to show_company_profile_path(params[:id])
    end
  end

  def index
    @all_types = CompanyType.pluck(:name)
    if params[:company_type]
      wanted = Company.all.select { |c| c.company_type.name == params[:company_type]}
    else
      wanted = Company.order(:id).all
    end
    @companies = wanted.group_by { |c| c.company_type.name}
    @types = @companies.keys
      respond_to do |format|
        format.js
        format.html
      end
  end
  
  def update
    @company = Company.find(params[:id])
    @company.assign_attributes(params[:company])
    @company.role.experience = @company.reverse_experience_cost(params[:experience_rev].to_f.round) if params[:experience_rev]
    
    @company.extra_costs = @company.calculate_change_penalty
    @company.values_decided = true
    @company.earlier_choice = @company.choice_to_s if @company.earlier_choice == nil
    #@company.calculate_mitigation_cost
    contract_ok = true
    if params[:contract]
      contract_ok = Contract.update_actual_launches(@company, params[:contract][:ids], params[:contract][:actual_launches])
    end
    @company.set_capital_validation
    if @company.save && contract_ok
      flash[:success] = "Successfully updated company information"
      redirect_to @company
    else
      flash.now[:error] = @company.errors.get(:capital).first unless (@company.errors.empty? || @company.errors.get(:capital) == nil)
      #@company = Company.find(params[:id])
      sell_price = @company.is_customer_facing? ? @company.role.sell_price : 0;
      market_id = @company.is_customer_facing? ? @company.role.market_id : 0;
      @stat_hash = @company.get_stat_hash(@company.role.service_level,@company.role.product_type, @company.risk_mitigation, @company.variable_cost, sell_price, market_id,
        @company.role.marketing, @company.role.unit_size, @company.role.number_of_units, @company.role.experience, @company.read_attribute(:fixed_sat_cost))
      flash.now[:error] = "Total amount of launches provided for companies has to between 0 and #{@company.max_capacity}" unless contract_ok
      render 'edit'
    end
  end
  
  def init
    @company = Company.find(params[:id])
    @stat_hash = @company.get_stat_hash(1,1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  end

  def update_init
    @company = Company.find(params[:id])
    @company.name = params[:name]
    @company.about_us = params[:about_us]
    if @company.save
      flash[:success] = "Successfully updated company information"
      @company.update_attribute(:initialised, true)
      redirect_to @company
    else
     @company = Company.find(params[:id])
     flash[:now] = "There was an error"
      render 'init'
    end
  end
  
  def get_stats
    @company = Company.find(Integer(params[:id]))
    puts "Company launches at start: #{@company.max_capacity}"
    level =  Integer(params[:level])
    type =  Integer(params[:type])
    risk_mit = Float(params[:risk_cost]).to_i
    marketing = Integer(params[:marketing]).to_i if params[:marketing]
    variable_cost = Float(params[:variable_cost]).to_i
    sell_price = Integer(params[:sell_price].gsub(/\s+/, ""))
    market_id = Integer(params[:market_id])
    capacity = Integer(params[:capacity]).to_i if params[:capacity]
    unit = Integer(params[:unit]).to_i if params[:unit]
    experience_rev = Integer(params[:experience_rev]).to_i if params[:experience_rev]
    experience = @company.reverse_experience_cost(experience_rev)
    fixed_sat = Float(params[:fixed_sat]).to_i if params[:fixed_sat]
    @stat_hash = @company.get_stat_hash(level, type, risk_mit, variable_cost, sell_price, market_id, marketing, capacity, unit, experience, fixed_sat)
    puts "Marketting cost: #{@stat_hash["marketing_cost"]}"
    respond_to do |format| 
      format.js
    end
  end

  def get_costs
    @company = Company.find(Integer(params[:id]))

    level =  Integer(params[:level])
    type =  Integer(params[:type])
    @company.role.service_level = level
    @company.role.product_type = type
    
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
    @stat_hash = @company.get_stat_hash(@company.role.service_level,@company.role.product_type, @company.risk_mitigation, @company.variable_cost, sell_price, market_id, @company.role.marketing,
      @company.role.unit_size, @company.role.number_of_units, @company.role.experience, @company.read_attribute(:fixed_sat_cost))
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

  def results
    if request.xhr?
      puts "Was ajax"
      
    else
      puts "Was not ajax"
      @company = Company.find(params[:id])
      @other_companies = Company.where("company_type_id = ?", @company.company_type_id)
      @risk = @company.get_risk
    end

    respond_to do |format|
      format.js
      format.html
    end
    
  end

  def text_data
    data = Company.company_data_txt
    render text: data
  end

  def expand
    @markets = Market.all
    @company = Company.find(params[:id])
    @expansions = @company.expanded_markets
  end

  def expand_update
    company = Company.find(params[:id])
    company.expand_markets(params[:markets])
    flash[:success] = "Market expansion updated"
    redirect_to company
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
