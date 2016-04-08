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

class CompanyProfilesController < ApplicationController

  before_filter :read_only, only: [:update]

  def edit
    @company = Company.find(params[:id])
  end

  def update
    cur = current_user
    current_user.update_attribute(:description, params[:description]) if params[:description]
    sign_in cur
    @company  = Company.find(params[:id])
    @company.update_attribute(:about_us, params[:about_us]) if params[:about_us]
    @company.update_attribute(:image, params[:image]) if params[:image]
    unless params[:image]
      puts "No image here"
    end
    @company.update_attribute(:for_investors, params[:for_investors]) if params[:for_investors]
    flash[:success] = "Updated data succesfully"
    redirect_to show_company_profile_path(@company)
  end

  def show
    @company = Company.find(params[:id])
    @network_chunk = @company.get_network_chunked
    @share_button = true
  end
end
