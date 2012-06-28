class OperatorRolesController < ApplicationController

  def index
    @operator_companies = OperatorRole.all
    respond_to do |f|
      f.js
      f.html
    end
  end
end
