class ServiceRolesController < ApplicationController

  def index
    @service_companies = ServiceRole.where("service_type = ?", params[:service_type])
    respond_to do |f|
      f.js
      f.html
    end
  end
end
