class AddVarMinToGames < ActiveRecord::Migration
  def change
    add_column :games, :low_budget_var_min, :decimal, :default => 10000
    add_column :games, :low_luxury_var_min, :decimal, :default => 15000
    add_column :games, :high_budget_var_min, :decimal, :default => 20000
    add_column :games, :high_luxury_var_min, :decimal, :default => 30000
  end
end
