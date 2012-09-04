class AddVarLimitsToGames < ActiveRecord::Migration
  def change
    add_column :games, :low_budget_var_max, :decimal, :default => 20000
    add_column :games, :low_luxury_var_max, :decimal, :default => 30000
    add_column :games, :high_budget_var_max, :decimal, :default => 50000
    add_column :games, :high_luxury_var_max, :decimal, :default => 80000
  end
end
