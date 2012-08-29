class ChangeColumnNamesInNetworkReports < ActiveRecord::Migration
  def change
    rename_column :network_reports, :realized_level, :max_launch
    rename_column :network_reports, :promised_level, :performed_launch
  end
end
