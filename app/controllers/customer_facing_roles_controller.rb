class CustomerFacingRolesController < ApplicationController
  def index
    @customerfacing_companies = CustomerFacingRole.all
    respond_to do |format|
      format.js
      format.html
    end
  end
end
