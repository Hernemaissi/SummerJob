class CompanyReportsController < ApplicationController

  def show
    @company = Company.find(params[:id])
    @company_reports = @company.company_reports.order("year ASC")
    @network_reports = nil
    if @company.network
      @network_reports = @company.network.network_reports.order("year ASC")
    end
  end
end
