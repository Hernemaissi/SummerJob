class AddVariableHashToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :variables, :text
  end
end
