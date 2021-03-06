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

class ServiceRolesController < ApplicationController
  before_filter :role_owner, only: [:edit, :update]
  before_filter :is_specialized, only: [:edit, :update]

  def index
    @service_companies = ServiceRole.where("service_type = ?", params[:service_type])
    @company_title = params[:service_type]
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    @service_role = ServiceRole.find(params[:id])
  end

  def update
    @sr = ServiceRole.find(params[:id])
    level_changed = false
    if @sr.service_level != params[:service_role][:service_level].to_i
      level_changed = true
    end
    @sr.update_attributes(params[:service_role])
    if @sr.save
      flash[:success] = "Succesfully updated changes"
      if level_changed
        @sr.company.network.total_profit -= 10000
        @sr.company.network.score -= 10000
        @sr.company.network.save!
      end
      redirect_to @sr.company
    else
      render 'edit'
    end
  end

  private

  def is_specialized
     @service_role = ServiceRole.find(params[:id])
     unless @service_role.specialized?
       flash[:error] = "You cannot change your service level if you are not a specialized company"
       redirect_to @service_role.company
     end
  end

  def role_owner
      @service_role = ServiceRole.find(params[:id])
      if !signed_in? || !current_user.group || !current_user.group.company || !(current_user.group.company.role == @service_role)
        unless signed_in? && current_user.teacher?
          flash[:error] = "You are not allowed to view this page"
          redirect_to(root_path)
        end
      end
    end
end
