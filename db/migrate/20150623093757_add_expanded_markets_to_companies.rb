class AddExpandedMarketsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :expanded_markets, :text
  end
end
