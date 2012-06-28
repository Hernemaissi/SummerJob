class OperatorRolesController < ApplicationController

  def index
    @operator_companies = OperatorRole.all
    respond_to do |format|
      format.js
      format.html
    end
  end
end
