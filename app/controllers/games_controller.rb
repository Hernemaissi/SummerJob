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
      @game.end_sub_round
    end
    redirect_to @game
  end

  def show
  end

  def index
  end
end
