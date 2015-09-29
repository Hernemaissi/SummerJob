class AddMarketDataToCompanyReports < ActiveRecord::Migration
  def change
    add_column :company_reports, :market_data, :text
  end
end
