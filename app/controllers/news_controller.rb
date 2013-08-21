class NewsController < ApplicationController
  before_filter :teacher_user,     only: [:destroy, :create, :new, :update, :edit]
  def new
    @news = News.new
  end

  def create
    @news = News.new(params[:news])
    if @news.save
      flash[:success] = "Succesfully create new news article"
      redirect_to news_index_path
    else
      render 'new'
    end
  end

  def edit
    @news = News.find(params[:id])
  end

  def update
    @news = News.find(params[:id])
    @news.update_attributes(params[:news])
    if @news.save
      flash[:success] = "Succesfully updated news article"
      redirect_to @news
    else
      render 'edit'
    end
  end

  def index
    @all_news = News.order("id").all
    if (params.has_key?("news_id"))
      @news = News.find(params[:news_id])
      @hide_direction = params[:direction]
      if @hide_direction != "left" && @hide_direction != "right"
        @hide_direction = "left"
      end
      @show_direction = (@hide_direction == "left") ? "right" : "left"
    else
      @news = @all_news.last
    end
    @first = @all_news.first
    @last = @all_news.last

    

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @news = News.find(params[:id])
    @all_news = News.order("id").all
    @first = @all_news.first
    @last = @all_news.last

    respond_to do |format|
      format.html
      format.js
    end
  end
end
