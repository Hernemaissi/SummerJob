class LoansController < ApplicationController

  def new
    @loan = Loan.new
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
