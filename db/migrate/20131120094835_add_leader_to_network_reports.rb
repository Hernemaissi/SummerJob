class AddLeaderToNetworkReports < ActiveRecord::Migration
  def change
    add_column :network_reports, :leader, :string
  end
end
