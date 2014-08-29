class AddMaxCustomersToNetworkReports < ActiveRecord::Migration
  def change
    add_column :network_reports, :max_customers, :integer
  end
end
