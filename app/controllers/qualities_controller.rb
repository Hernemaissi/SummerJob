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

class QualitiesController < ApplicationController
  before_filter :teacher_user

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

    respond_to do |format|
      format.html
      format.json { render :json => @quality.qualityvalues }
    end
  end

  def index
    @qualities = Quality.order("id ASC")
  end

  
  

end
