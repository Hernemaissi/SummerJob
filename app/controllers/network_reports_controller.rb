class NetworkReportsController < ApplicationController
  before_filter :teacher_user, only: [:index]

  def show
    @report = NetworkReport.find(params[:id])
  end

  def index
    @customer_facing_roles = CustomerFacingRole.all
  end

end
