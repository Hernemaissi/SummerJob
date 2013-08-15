class CompanyReportsController < ApplicationController

  def show
    @company = Company.find(params[:id])
    @company_reports = @company.company_reports.order("year ASC")
    @network_reports = nil
    @customer_facing_companies = @company.get_customer_facing_company
    if @customer_facing_companies != nil
      @network_reports = []
       @customer_facing_companies.each do |c|
         @network_reports.concat(c.role.network_reports.all)
       end
       @network_reports.sort_by! { |r| r.year }
    end
  end
end
