class AddRelativeNetCostToNetworkReports < ActiveRecord::Migration
  def change
    add_column :network_reports, :relative_net_cost, :decimal
  end
end
