class AddAccidentCostToCompanyReports < ActiveRecord::Migration
  def change
    add_column :company_reports, :accident_cost, :decimal, :precision => 20, :scale => 2, :default => 0.0
  end
end
