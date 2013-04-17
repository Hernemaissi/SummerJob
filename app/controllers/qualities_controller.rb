class QualitiesController < ApplicationController
  def new
    @quality = Quality.new
    3.times {@quality.qualityvalues.build }
    @amount = 3
  end

  def create
    @quality = Quality.new(params[:quality])
    if @quality.save
      flash[:success] = "Succesfully created a new parameter!"
      redirect_to @quality
    else
      render 'new'
    end
  end

 def update
    @quality = Quality.find(params[:id])
    @quality.update_attributes(params[:quality])
    if @quality.save
      flash[:success] = "Succesfully updated Parameter"
      redirect_to @quality
    else
      render 'edit'
    end
  end

  def edit
    @quality = Quality.find(params[:id])
    @amount = @quality.qualityvalues.length
  end

  def destroy
  end

  def show
    @quality = Quality.find(params[:id])
  end

  def index
    @qualities = Quality.all
  end

  def add_option
    if params[:id]
      @quality = Quality.find(params[:id])
      @quality.qualityvalues.build
      @amount = @quality.qualityvalues.length
    else
      @amount = params[:amount].to_i + 1
      @quality = Quality.new
      @amount.times {@quality.qualityvalues.build }
    end
    respond_to do |format|
      format.js
    end
  end
  

end
