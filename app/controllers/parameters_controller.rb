class ParametersController < ApplicationController

  def edit
    @p = Parameters.instance
  end

  def update
    p = Parameters.instance
    p.update_attributes(params[:parameters])
    p.save!
    redirect_to edit_parameter_path(p)
  end
end
