class CompanyReportsController < ApplicationController

  before_filter :company_owner

  def show
    @company = Company.find(params[:id])
    @company_reports = @company.company_reports.order("year ASC")
    @network_reports = @company.network_reports.order("year ASC")
  end
end
