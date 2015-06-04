class AddMarketIdToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :market_id, :integer
  end
end
