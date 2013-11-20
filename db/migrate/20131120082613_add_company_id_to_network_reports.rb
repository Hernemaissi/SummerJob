class AddCompanyIdToNetworkReports < ActiveRecord::Migration
  def change
    add_column :network_reports, :company_id, :integer
  end
end
