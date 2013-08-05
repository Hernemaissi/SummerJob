class NetworkReportsController < ApplicationController

  def show
    @report = NetworkReport.find(params[:id])
  end

  def index
    @customer_facing_roles = CustomerFacingRole.all
  end

end
