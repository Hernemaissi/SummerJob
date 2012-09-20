class AddBunchOfFieldsToGames < ActiveRecord::Migration
  def change
    rename_column :games, :low_budget_min, :low_budget_min_operator
    rename_column :games, :low_budget_max, :low_budget_max_operator
    rename_column :games, :low_budget_cap, :low_budget_cap_operator
    rename_column :games, :high_budget_min, :high_budget_min_operator
    rename_column :games, :high_budget_max, :high_budget_max_operator
    rename_column :games, :high_budget_cap, :high_budget_cap_operator
    rename_column :games, :low_luxury_min, :low_luxury_min_operator
    rename_column :games, :low_luxury_max, :low_luxury_max_operator
    rename_column :games, :low_luxury_cap, :low_luxury_cap_operator
    rename_column :games, :high_luxury_min, :high_luxury_min_operator
    rename_column :games, :high_luxury_max, :high_luxury_max_operator
    rename_column :games, :high_luxury_cap, :high_luxury_cap_operator
    rename_column :games, :low_budget_var_max, :low_budget_var_max_operator
    rename_column :games, :low_luxury_var_max, :low_luxury_var_max_operator
    rename_column :games, :high_budget_var_max, :high_budget_var_max_operator
    rename_column :games, :high_luxury_var_max, :high_luxury_var_max_operator
    rename_column :games, :low_budget_var_min, :low_budget_var_min_operator
    rename_column :games, :low_luxury_var_min, :low_luxury_var_min_operator
    rename_column :games, :high_budget_var_min, :high_budget_var_min_operator
    rename_column :games, :high_luxury_var_min, :high_luxury_var_min_operator


    add_column :games, :low_budget_min_customer, :decimal, :default => 1000
    add_column :games, :low_budget_max_customer, :decimal, :default => 2000
    add_column :games, :low_budget_cap_customer, :integer, :default => 20
    add_column :games, :high_budget_min_customer, :decimal, :default => 3000
    add_column :games, :high_budget_max_customer, :decimal, :default => 5000
    add_column :games, :high_budget_cap_customer, :integer, :default => 40
    add_column :games, :low_luxury_min_customer, :decimal, :default => 10000
    add_column :games, :low_luxury_max_customer, :decimal, :default => 20000
    add_column :games, :low_luxury_cap_customer, :integer, :default => 10
    add_column :games, :high_luxury_min_customer, :decimal, :default => 50000
    add_column :games, :high_luxury_max_customer, :decimal, :default => 100000
    add_column :games, :high_luxury_cap_customer, :integer, :default => 5
    add_column :games, :low_budget_var_max_customer, :decimal, :default => 20000
    add_column :games, :low_luxury_var_max_customer, :decimal, :default => 30000
    add_column :games, :high_budget_var_max_customer, :decimal, :default => 50000
    add_column :games, :high_luxury_var_max_customer, :decimal, :default => 80000
    add_column :games, :low_budget_var_min_customer, :decimal, :default => 10000
    add_column :games, :low_luxury_var_min_customer, :decimal, :default => 15000
    add_column :games, :high_budget_var_min_customer, :decimal, :default => 20000
    add_column :games, :high_luxury_var_min_customer, :decimal, :default => 30000

    add_column :games, :low_budget_min_tech, :decimal, :default => 1000
    add_column :games, :low_budget_max_tech, :decimal, :default => 2000
    add_column :games, :low_budget_cap_tech, :integer, :default => 20
    add_column :games, :high_budget_min_tech, :decimal, :default => 3000
    add_column :games, :high_budget_max_tech, :decimal, :default => 5000
    add_column :games, :high_budget_cap_tech, :integer, :default => 40
    add_column :games, :low_luxury_min_tech, :decimal, :default => 10000
    add_column :games, :low_luxury_max_tech, :decimal, :default => 20000
    add_column :games, :low_luxury_cap_tech, :integer, :default => 10
    add_column :games, :high_luxury_min_tech, :decimal, :default => 50000
    add_column :games, :high_luxury_max_tech, :decimal, :default => 100000
    add_column :games, :high_luxury_cap_tech, :integer, :default => 5
    add_column :games, :low_budget_var_max_tech, :decimal, :default => 20000
    add_column :games, :low_luxury_var_max_tech, :decimal, :default => 30000
    add_column :games, :high_budget_var_max_tech, :decimal, :default => 50000
    add_column :games, :high_luxury_var_max_tech, :decimal, :default => 80000
    add_column :games, :low_budget_var_min_tech, :decimal, :default => 10000
    add_column :games, :low_luxury_var_min_tech, :decimal, :default => 15000
    add_column :games, :high_budget_var_min_tech, :decimal, :default => 20000
    add_column :games, :high_luxury_var_min_tech, :decimal, :default => 30000

    add_column :games, :low_budget_min_supply, :decimal, :default => 1000
    add_column :games, :low_budget_max_supply, :decimal, :default => 2000
    add_column :games, :low_budget_cap_supply, :integer, :default => 20
    add_column :games, :high_budget_min_supply, :decimal, :default => 3000
    add_column :games, :high_budget_max_supply, :decimal, :default => 5000
    add_column :games, :high_budget_cap_supply, :integer, :default => 40
    add_column :games, :low_luxury_min_supply, :decimal, :default => 10000
    add_column :games, :low_luxury_max_supply, :decimal, :default => 20000
    add_column :games, :low_luxury_cap_supply, :integer, :default => 10
    add_column :games, :high_luxury_min_supply, :decimal, :default => 50000
    add_column :games, :high_luxury_max_supply, :decimal, :default => 100000
    add_column :games, :high_luxury_cap_supply, :integer, :default => 5
    add_column :games, :low_budget_var_max_supply, :decimal, :default => 20000
    add_column :games, :low_luxury_var_max_supply, :decimal, :default => 30000
    add_column :games, :high_budget_var_max_supply, :decimal, :default => 50000
    add_column :games, :high_luxury_var_max_supply, :decimal, :default => 80000
    add_column :games, :low_budget_var_min_supply, :decimal, :default => 10000
    add_column :games, :low_luxury_var_min_supply, :decimal, :default => 15000
    add_column :games, :high_budget_var_min_supply, :decimal, :default => 20000
    add_column :games, :high_luxury_var_min_supply, :decimal, :default => 30000
  end
end
