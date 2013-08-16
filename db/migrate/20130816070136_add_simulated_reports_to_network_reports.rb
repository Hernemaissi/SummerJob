class AddSimulatedReportsToNetworkReports < ActiveRecord::Migration
  def change
    add_column :network_reports, :simulated_report, :boolean, :default => true
  end
end
