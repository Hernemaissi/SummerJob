class AddRiskIdToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :risk_id, :integer
  end
end
