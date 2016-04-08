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

class OperatorRolesController < ApplicationController
  before_filter :role_owner, only: [:edit, :update]

  def index
    @operator_companies = OperatorRole.all
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    @operator_company_role = OperatorRole.find(params[:id])
  end

  def update
    @op = OperatorRole.find(params[:id])
    capacity_changed = false
    type_changed = false
    level_changed = false
    if @op.capacity != params[:operator_role][:capacity].to_i
      capacity_changed = true
    end
    if @op.product_type != params[:operator_role][:product_type].to_i
      type_changed = true
    end
    if @op.service_level != params[:operator_role][:service_level].to_i
      level_changed = true
    end
    @op.update_attributes(params[:operator_role])
    if @op.save
      if @op.company.network
        if capacity_changed
          @op.company.network.total_profit -= 10000
          @op.company.network.score -= 10000
        end
        if type_changed
          @op.company.network.total_profit -= 10000
          @op.company.network.score -= 10000
        end
        if level_changed
          @op.company.network.total_profit -= 10000
          @op.company.network.score -= 10000
        end
        if type_changed || capacity_changed || level_changed
          @op.company.network.save!
        end
      end
      flash[:success] = "Succesfully updated choices"
      redirect_to @op.company
    else
      render 'edit'
    end
  end

  private

  def role_owner
      @operator_company_role = OperatorRole.find(params[:id])
      if !signed_in? || !current_user.group || !current_user.group.company || !(current_user.group.company.role == @operator_company_role)
        unless signed_in? && current_user.teacher?
          flash[:error] = "You are not allowed to view this page"
          redirect_to(root_path)
        end
      end
    end
end
