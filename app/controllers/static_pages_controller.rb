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

class StaticPagesController < ApplicationController
  skip_filter :still_calculating, only: [:busy, :progress, :home]
  skip_filter :finished, only: [:results, :busy, :home]
  before_filter :game_over, only: [:results]

  def home
    @share_button = true
  end

  def help
  end
  
  def about
  end

  def busy
    @value = Rails.cache.read("progress")
  end

  def results
    @customer_facing_roles = Company.order("total_profit DESC").reject { |x| !x.is_customer_facing? }
    @ranked_companies = Company.rank_companies
  end

  def progress
    if @game.calculating
      @value = Rails.cache.read("progress")
    else
      @value = 0
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def game_over
    unless @game.finished
      redirect_to root_path
    end
  end
  
end
