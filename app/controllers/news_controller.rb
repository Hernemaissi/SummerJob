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

  def destroy
    News.find(params[:id]).destroy
    flash[:success] = "News destroyed."
    redirect_to news_index_path
  end

  def index
    @all_news = News.order("id").all
    if (params.has_key?("news_id"))
      @news = News.find_by_id(params[:news_id])
      @hide_direction = params[:direction]
      @news = News.find_next(params[:news_id].to_i, @hide_direction) if @news == nil
      @news = News.all.first if @news == nil
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
