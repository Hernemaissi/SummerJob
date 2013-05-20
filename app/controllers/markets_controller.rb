class MarketsController < ApplicationController
  def new
    @market = Market.new
  end

  def create
    @market = Market.new(params[:market])
    if @market.save
      flash[:success] = "Succesfully created a new market!"
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
  end

  def update
    @market = Market.find(params[:id])
    @market.update_attributes(params[:market])
    if @market.save
      flash[:success] = "Succesfully updated market"
      redirect_to @market
    else
      render 'edit'
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

    for i in 0..@market.lb_max_price
      sales_made = Market.get_test_sales(i, @max_capacity, 1, 1, @market)
      launches = Market.get_test_launches(test_company, sales_made, @max_capacity)
      @profits << sales_made * i
      @costs << (test_company.total_fixed_cost + launches * test_company.variable_cost).to_i
    end

    @value_table = []
    for j in 0...@profits.length
      @value_table << [j,   @profits[j], @costs[j]]
    end

    respond_to do |format|
      format.js
    end
  end

end
