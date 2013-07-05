class GamesController < ApplicationController

  before_filter :teacher_user,only: [:update, :revert]
  skip_filter :finished, only: [:update]
  before_filter :signed_in_user

  def new
  end

  def edit
  end

  def update
    if params[:round]
      if Integer(params[:round]) > 0 && Integer(params[:round]) <= @game.max_rounds
        @game.current_round = params[:round]
        @game.save!
      end
    end
    if params[:sub_round]
      @game.end_sub_round
    end
    if params[:finished]
      @game.finished = params[:finished]
      @game.save!
    end
    if params[:publish]
      @game.results_published = true
      flash[:success] = "Results are now published for this round"
      @game.save!
    end
    if params[:edit]
      @game.update_attributes(params[:game])
      @game.save!
      Company.check_limits
      flash[:success] = "Values updated"
    end
    redirect_to @game
  end

  def show
  end

  def index
  end

  def revert
    Company.revert_changes
    CompanyReport.delete_simulated_reports
    @game = Game.get_game
    @game.sub_round -= 1
    @game.save!
    redirect_to @game
  end

end
