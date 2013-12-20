class AddBreakCostToCompanyReports < ActiveRecord::Migration
  def change
    add_column :company_reports, :break_cost, :integer, :default => 0
  end
end
