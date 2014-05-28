class AddCostsToCompanyReports < ActiveRecord::Migration
  def change
    add_column :company_reports, :capacity_cost, :decimal
    add_column :company_reports, :unit_cost, :decimal
    add_column :company_reports, :experience_cost, :decimal
    add_column :company_reports, :marketing_cost, :decimal
  end
end
