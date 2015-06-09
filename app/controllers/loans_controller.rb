class LoansController < ApplicationController

  def new
    if request.xhr?
      #@loan = Loan.new(params[:loan])
      #@loan.interest = @loan.calculate_interest
      #@payments = @loan.payments
    else
      @loan = Loan.new
      market = current_user.company.get_markets.first
      @interest = market.interest
      @market_name = market.name
    end

    respond_to do |format|

      format.html
      format.js

    end


  end

  def create
    loan = Loan.new(params[:loan])
    loan.company = current_user.company
    loan.interest = loan.calculate_interest
    loan.remaining = loan.duration
    if loan.save
      current_user.company.update_attribute(:capital, current_user.company.capital + loan.loan_amount)
      flash[:success] = "You have taken a loan"
      redirect_to loan
    else
      render 'new'
    end
  end

  def show
    @loan = Loan.find(params[:id])
    @payments = @loan.payments
  end

  def index
  end

end
