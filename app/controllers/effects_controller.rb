class EffectsController < ApplicationController
  def new
    @effect = Effect.new
  end

  def create
    @effect = Effect.new(params[:effect])
    if @effect.save
      flash[:success] = "Succesfully created a new effect!"
      redirect_to @effect
    else
      render 'new'
    end
  end

  def edit
    @effect = Effect.find(params[:id])
  end

 def update
    @effect = Effect.find(params[:id])
    @effect.update_attributes(params[:effect])
    if @effect.save
      flash[:success] = "Succesfully updated effect"
      redirect_to @effect
    else
      render 'edit'
    end
  end

  def index
    @effects = Effect.all
  end

  def show
    @effect = Effect.find(params[:id])
  end
end
