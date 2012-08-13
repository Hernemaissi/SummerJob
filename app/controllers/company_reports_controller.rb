class CompanyReportsController < ApplicationController

  def show
    @report = CompanyReport.find(params[:id])
  end
end
