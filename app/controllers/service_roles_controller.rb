class ServiceRolesController < ApplicationController

  def index
    @service_companies = ServiceRole.where("service_type = ?", params[:service_type])
    @company_title = params[:service_type]
    respond_to do |format|
      format.js
      format.html
    end
  end
end
