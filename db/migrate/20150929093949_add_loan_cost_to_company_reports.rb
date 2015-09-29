class AddLoanCostToCompanyReports < ActiveRecord::Migration
  def change
    add_column :company_reports, :loan_cost, :decimal, precision: 20, scale: 2, default: 0.0
    add_column :company_reports, :expansion_cost, :decimal, precision: 20, scale: 2, default: 0.0
  end
end
