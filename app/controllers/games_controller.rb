class GamesController < ApplicationController

  before_filter :teacher_user,only: [:update, :revert, :show, :accept]
  skip_filter :finished, only: [:update]
  before_filter :signed_in_user

  def new
  end

  def edit
    @versions = Game.get_game.versions.last.reify != nil
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
    if params[:sign_up]
      @game.update_attribute(:sign_up_open, params[:sign_up])
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
    NetworkReport.delete_simulated_reports
    @game = Game.get_game
    @game.sub_round -= 1
    @game.sub_round_decided = true
    @game.results_published = true
    @game.calculating = false
    @game.save!
    redirect_to @game
  end

  def accept
    CompanyReport.accept_simulated_reports
    NetworkReport.accept_simulated_reports
    Contract.update_contracts
    @game = Game.get_game
    @game.update_attributes(:sub_round_decided => true, :calculating => false, :results_published => true);
    redirect_to @game
  end

  def simulate
    market_id = params[:test_market].to_i
    segment = params[:test_segment]
    level = segment.split(",")[0].to_i
    type = segment.split(",")[1].to_i
    customer_sat = params[:customer_satisfaction].to_f
    @h = @game.test_values(market_id, type, level, customer_sat)
    respond_to do |format|
      format.js
    end
  end

end
