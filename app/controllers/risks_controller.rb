class RisksController < ApplicationController

  def new
    @risk = Risk.new
  end

  def create
    @risk = Risk.new(params[:risk])
    if @risk.save
      flash[:success] = "Succesfully created a new risk!"
      redirect_to @risk
    else
      render 'new'
    end
  end

  def edit
    @risk = Risk.find(params[:id])
  end

  def update
  end

  def show
    @risk = Risk.find(params[:id])
  end

  def index
    @risks = Risk.all
  end

  def destroy
  end
end
