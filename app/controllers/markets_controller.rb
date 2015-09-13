class MarketsController < ApplicationController
  before_filter :teacher_user

  def new
    @market = Market.new
  end

  def create
    @market = Market.new(params[:market])
    @market.satisfaction_limits = params[:satisfaction_limits]
    if @market.save
      flash[:success] = "Succesfully created a new market!"
      @market.update_attribute(:variables, Market.parse_variables(params[:variables_string])) unless params[:variables_string].empty?
      redirect_to @market
    else
      render 'new'
    end
  end

  def edit
    @market =  Market.find(params[:id])
    require 'googlecharts'
    @url =  Gchart.line( :data => [17, 17, 11, 8, 2],
              :axis_with_labels => ['x', 'y'],
              :axis_range => [nil, [2,17,5]])

    respond_to do |format|

      format.html
      format.js

      end
  end

  def update
    @market = Market.find(params[:id])
    @market.update_attributes(params[:market])
    @market.satisfaction_limits = params[:satisfaction_limits]
    if @market.save
      flash[:success] = "Succesfully updated market"
      @market.update_attribute(:variables, Market.parse_variables(params[:variables_string])) unless params[:variables_string].empty?
      respond_to do |format|

      format.html {redirect_to edit_market_path(@market)}
      format.js

      end
      
    else
     respond_to do |format|

      format.html {render 'edit'}
      format.js

      end
      
    end
  end

  def show
    @market = Market.find(params[:id])
  end

  def index
    @markets = Market.all
  end

  def destroy
  end

  def debug
    @market = Market.find(params[:id])
    @customers = @market.complete_sales(0, @market.customer_amount, Game.get_game)
  end

  def changes
    @market = Market.find(params[:id])
    puts "Param value: #{params}"
    puts "Market starting budget hop sweet: #{@market.lb_amount}"
    @market.assign_attributes(params[:market])
    puts "Market after budget hop sweet: #{@market.lb_amount}"
    @value = @market.changed?
    if @value
      @news = @market.generate_news
    end
    respond_to do |format|
      format.js
    end
  end

  def test
    @markets = Market.all
    @companies = Company.order(:company_type_id).chunk{ |c| c.company_type.id }
  end

  def test_update
    @market = Market.find(params[:market][:market_id])
    company_list = params[:company_list]
    companies = []
    customer_role = nil
    company_list.values.each do |current|
      c = Company.find(current)
      companies << c
      customer_role = c.role if c.is_customer_facing?
    end
    @sat = Network.test_network_satisfaction_weighted(customer_role, companies, @market)
    @costs = Network.test_network_costs(companies)
    @acc = Market.test_sales(customer_role, @market)
  end

  def graph
    @capacity = params["capacity"].to_i
    @quality = params["quality"].to_i
    @variable = params["variable"].to_i
    @market = Market.find(params["id"])

    test_company = Company.new
    test_company.capacity_cost = @capacity
    test_company.risk_control_cost = (@quality / 100) * @capacity
    test_company.variable_cost = @variable
    test_company.service_type = params["company"]["type"]
    test_company.create_role
    test_company.role.service_level = params["service_level"].to_i
    test_company.role.product_type = params["product_type"].to_i
    @max_capacity = test_company.calculate_launch_capacity(@capacity, params["service_level"].to_i, params["product_type"].to_i)
    puts "Max cap #{@max_capacity}"

    @profits = []
    @costs = []
    @prices = []

    step_value = (@market.get_graph_values(test_company.service_level, test_company.product_type)[2] / 1000)

    for i in (0..@market.get_graph_values(test_company.service_level, test_company.product_type)[2]).step(step_value)
      sales_made = Market.get_test_sales(i, @max_capacity, test_company.service_level, test_company.product_type, @market)
      launches = Market.get_test_launches(test_company, sales_made, @max_capacity)
      @profits << sales_made * i.to_i
      @costs << (test_company.total_fixed_cost + launches * test_company.variable_cost).to_i
      @prices << i.to_i
    end

    @value_table = []
    for j in 0...@prices.length
      @value_table << [@prices[j],   @profits[j], @costs[j]]
    end

    test_company.destroy_role

    respond_to do |format|
      format.js
    end
  end

  

end
