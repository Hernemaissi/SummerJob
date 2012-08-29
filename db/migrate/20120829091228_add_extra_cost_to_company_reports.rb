class AddExtraCostToCompanyReports < ActiveRecord::Migration
  def change
    add_column :company_reports, :extra_cost, :decimal, :default => 0
  end
end
