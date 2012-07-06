class GamesController < ApplicationController

  before_filter :teacher_user,only: [:update]

  def new
  end

  def edit
  end

  def update
    if params[:round]
      if Integer(params[:round]) > 0 && Integer(params[:round]) <= @game.max_rounds
        @game.current_round = params[:round]
        @game.save
      end
    else
      @game.sub_round = params[:sub_round]
      @game.calculate_static_costs
      @game.calculate_contract_profit
      @game.save
    end
    redirect_to @game
  end

  def show
  end

  def index
  end
end
