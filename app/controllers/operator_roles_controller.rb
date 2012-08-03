class OperatorRolesController < ApplicationController

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
end
