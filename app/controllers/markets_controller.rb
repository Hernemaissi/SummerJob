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
    companies = @market.customer_facing_roles
    @customers = @market.get_customers
    @scores = @market.get_score_array(@customers, companies)
    @market.customer_facing_roles.each do |c|
      c.register_sales(@customers) if c.network?
    end
  end

end
