class StaticPagesController < ApplicationController
  skip_filter :still_calculating, only: [:busy, :progress]
  skip_filter :finished, only: [:results]

  def home
    
  end

  def help
  end
  
  def about
  end

  def busy
    @value = Rails.cache.read("progress")
  end

  def results
    @networks = Network.order("score DESC")
    @ranked_operators = Company.where(:service_type => Company.types[1]).order("total_profit DESC")
    @ranked_customers = Company.where(:service_type => Company.types[0]).order("total_profit DESC")
    @ranked_tech = Company.where(:service_type => Company.types[2]).order("total_profit DESC")
    @ranked_supplies = Company.where(:service_type => Company.types[3]).order("total_profit DESC")
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
  
end
