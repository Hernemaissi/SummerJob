class NewsController < ApplicationController
  def new
    @news = News.new
  end

  def create
    @news = News.new(params[:news])
    if @news.save
      flash[:success] = "Succesfully create new news article"
      redirect_to @news
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
    @news = News.all
  end

  def show
    @news = News.find(params[:id])
    @all_news = News.order("id").all
    @first = @all_news.first
    @last = @all_news.last
  end
end
