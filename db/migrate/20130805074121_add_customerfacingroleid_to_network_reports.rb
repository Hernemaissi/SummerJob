class AddCustomerfacingroleidToNetworkReports < ActiveRecord::Migration
  def change
    add_column :network_reports, :customer_facing_role_id, :integer
  end
end
