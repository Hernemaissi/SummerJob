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

  def destroy
    Effect.find(params[:id]).destroy
    flash[:success] = "Effect destroyed."
    redirect_to effects_path
  end
end
