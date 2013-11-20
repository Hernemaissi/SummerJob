class AddNetworkReportsCompaniesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :companies_network_reports, :id => false do |t|
      t.integer :company_id
      t.integer :network_report_id
    end
  end

  def self.down
    drop_table :companies_network_reports
  end
end
