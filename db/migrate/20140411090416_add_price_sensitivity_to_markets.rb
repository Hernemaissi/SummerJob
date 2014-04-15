class AddPriceSensitivityToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :price_sensitivity, :decimal
  end
end
