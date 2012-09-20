class AddLaunchCostToCompanyReports < ActiveRecord::Migration
  def change
    add_column :company_reports, :launch_capacity_cost, :decimal, :default => 0
  end
end
