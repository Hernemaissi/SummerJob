class AddMarketDataToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :market_data, :text
  end
end
