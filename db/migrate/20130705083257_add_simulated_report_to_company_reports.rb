class AddSimulatedReportToCompanyReports < ActiveRecord::Migration
  def change
    add_column :company_reports, :simulated_report, :boolean, :default => true
  end
end
