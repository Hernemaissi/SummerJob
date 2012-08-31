class AddNetCostToNetworkReports < ActiveRecord::Migration
  def change
    add_column :network_reports, :net_cost, :decimal, :default => 0.0
  end
end
