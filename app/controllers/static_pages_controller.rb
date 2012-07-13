class StaticPagesController < ApplicationController
  skip_filter :still_calculating, only: [:busy]

  def home
  end

  def help
  end
  
  def about
  end

  def busy
    @value = Rails.cache.read("progress")
  end
  
end
