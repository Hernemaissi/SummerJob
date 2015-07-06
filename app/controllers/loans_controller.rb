class LoansController < ApplicationController

  def new
    if request.xhr?
      #@loan = Loan.new(params[:loan])
      #@loan.interest = @loan.calculate_interest
      #@payments = @loan.payments
    else
      @company = Company.find(params[:company_id])
      @loan = @company.loans.new
      market = @company.role.market
      redirect_to @company if !market
      @interest = @loan.calculate_interest
      @duration = (Game.get_game.max_sub_rounds + 1) - Game.get_game.sub_round
      @market_name = market.name
    end

    respond_to do |format|

      format.html
      format.js

    end


  end

  def create
    company = Company.find(params[:company_id])
    loan = company.loans.new(params[:loan])
    loan.interest = loan.calculate_interest
    loan.duration = (Game.get_game.max_sub_rounds + 1) - Game.get_game.sub_round
    loan.remaining = loan.duration
    if loan.save
      company.update_attribute(:capital, company.capital + loan.loan_amount)
      flash[:success] = "You have taken a loan"
      redirect_to company_loan_path(company,loan)
    else
      render 'new'
    end
  end

  def show
    @loan = Loan.find(params[:id])
    @payments = @loan.payments
  end

  def index
    @company = Company.find(params[:company_id])
    @loans = Company.find(params[:company_id]).loans
  end

end
