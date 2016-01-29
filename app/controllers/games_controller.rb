class GamesController < ApplicationController

  before_filter :teacher_user,only: [:update, :revert, :show, :accept, :edit, :test_new, :test_create, :test_destroy]
  skip_filter :finished, only: [:update]
  skip_filter :still_calculating
  before_filter :signed_in_user
  before_filter :not_calculating, only: [:accept, :revert]

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
      redirect_to results_path and return
    end
    if params[:publish]
      @game.results_published = true
      flash[:success] = "Results are now published for this round"
      @game.save!
    end
    if params[:edit]
      if @game.update_attributes(params[:game])
        @game.save!
        flash[:success] = "Values updated"
      else
        render 'edit' and return
      end
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
    @game = Game.get_game
    @game.revert
    redirect_to @game
  end

  def accept
    @game = Game.get_game
    @game.accept
    redirect_to @game
  end

  def test_new
    
  end

  def test_create
    network_amount = params[:network_amount].to_i
    user_amount = params[:user_amount].to_i
    Game.get_game.create_test_environment(network_amount, user_amount)
    flash[:success] = "Test companies, users and market created"
    Game.get_game.update_attribute(:setup, true)
    redirect_to @game
  end

  def test_destroy
    @game.destroy_test_environment
    flash[:success] = "Successfully destroyed all test companies, users and markets"
    Game.get_game.update_attribute(:setup, false)
    redirect_to @game
  end

  

 private

  def not_calculating
    unless @game.calculating
      flash[:error] = "Decision already made"
      redirect_to @game
    end
  end

 

end
