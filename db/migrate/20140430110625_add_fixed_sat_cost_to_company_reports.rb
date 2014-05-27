class AddFixedSatCostToCompanyReports < ActiveRecord::Migration
  def change
    add_column :company_reports, :fixed_sat_cost, :decimal
  end
end
