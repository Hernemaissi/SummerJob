class StaticPagesController < ApplicationController
  skip_filter :still_calculating, only: [:busy, :progress]

  def home
  end

  def help
  end
  
  def about
  end

  def busy
    @value = Rails.cache.read("progress")
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
