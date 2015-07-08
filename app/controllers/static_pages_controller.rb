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
