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
    @risk = Risk.find(params[:id])
    @risk.update_attributes(params[:risk])
    if @risk.save
      flash[:success] = "Succesfully updated risk"
      redirect_to @risk
    else
      render 'edit'
    end
  end

  def show
    @risk = Risk.find(params[:id])
  end

  def index
    @risks = Risk.all
  end

  def destroy
    Risk.find(params[:id]).destroy
    flash[:success] = "Risk destroyed."
    redirect_to risks_path
  end
end
