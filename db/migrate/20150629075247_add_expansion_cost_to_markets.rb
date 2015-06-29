class AddExpansionCostToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :expansion_cost, :decimal, precision: 20, scale: 2, default: 0.0
  end
end
