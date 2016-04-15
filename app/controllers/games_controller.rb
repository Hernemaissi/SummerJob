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

class GamesController < ApplicationController

  before_filter :teacher_user,only: [:update, :revert, :show, :accept, :edit, :test_new, :test_create, :test_destroy, :reset]
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
      @game.update_attribute(:in_progress, true)
      @game.delay.end_sub_round
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
    if params[:read_only]
      @game.update_attribute(:read_only, params[:read_only])
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

  def test_perform
    @test = params[:test] == "1"
    if @test
      consider_others = params[:others]
      consider_others = (consider_others == '1') ? true : false
      @array = Game.get_game.run_tests(consider_others)
      if @array.nil?
        flash[:error] = "Set test market values first"
        redirect_to @game
      end
    end
  end

  def reset
    Game.reset_game(current_user.id)
    redirect_to root_path
  end

  

 private

  def not_calculating
    unless @game.calculating
      flash[:error] = "Decision already made"
      redirect_to @game
    end
  end

 

end
