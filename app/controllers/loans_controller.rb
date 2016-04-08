=begin
This file is part of Network Service Business Game.

    Network Service Business Game is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Network Service Business Game is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Network Service Business Game.  If not, see <http://www.gnu.org/licenses/>
=end

class LoansController < ApplicationController

  before_filter :has_market, only: [:new, :create]
  before_filter :is_owner
  before_filter :read_only, only: [:new, :create]

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
      @interest = Loan.calculate_interest(@company)
      @duration = (Game.get_game.max_sub_rounds + 1) - Game.get_game.sub_round
      @market_name = market.name
    end

    respond_to do |format|

      format.html
      format.js

    end


  end

  def create
    @company = Company.find(params[:company_id])
    amount = params[:loan][:loan_amount]
    @duration = (Game.get_game.max_sub_rounds + 1) - Game.get_game.sub_round
    @duration = (@duration == 1) ? 2 : @duration
    @loan = Loan.take_loan(@company, amount, @duration)
    if @loan.valid?
      flash[:success] = "You have taken a loan"
      redirect_to company_loan_path(@company, @loan)
    else
      @interest = @loan.interest
      @market_name = @company.role.market.name
      render 'new'
    end
  end


  def show
    @loan = Loan.find(params[:id])
    @payments = @loan.payments
  end

  def index
    @company = Company.find(params[:company_id])
    @loans = Company.find(params[:company_id]).loans.order(:id)
  end

  private

  def has_market
    @company = Company.find(params[:company_id])
    unless @company.role.market
      flash[:error] = "You must choose a primary market before deciding on loans"
      redirect_to @company
    end
  end

  def is_owner
    @company = Company.find(params[:company_id])
    unless current_user.isOwner?(@company)
      flash[:error] = "You cannot view this page"
      redirect_to root_path
    end
  end

end
