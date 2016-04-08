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

class CompanyTypesController < ApplicationController
  before_filter :teacher_user

  def new
    @company_type = CompanyType.new
  end

  def create
    company_type = CompanyType.new(params[:company_type])
    if company_type.save
      flash[:success] = "New company type created successfully"
      redirect_to company_types_url
    else
      render new
    end
  end

  def show
  end

  def index
    @types = CompanyType.order("id").all
  end

  def edit
    @company_type = CompanyType.find(params[:id])
  end

  def update
    company_type = CompanyType.find(params[:id])
    company_type.update_attributes(params[:company_type])
    if company_type.save
      flash[:success] = "Company type updated successfully"
      redirect_to company_types_url
    else
      render edit
    end
  end

  def destroy
    CompanyType.find(params[:id]).destroy
    flash[:success] = "Company type destroyed."
    redirect_to company_types_path
  end


end
