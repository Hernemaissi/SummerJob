class ChangeDecimalScales < ActiveRecord::Migration
  def up

    change_column :games, :low_budget_min_operator, :decimal, :default => 1000, :scale => 0, :precision => 15
    change_column :games, :low_budget_max_operator, :decimal, :default => 2000, :scale => 0, :precision => 15
    change_column :games, :low_budget_cap_operator, :integer, :default => 20
    change_column :games, :high_budget_min_operator, :decimal, :default => 3000, :scale => 0, :precision => 15
    change_column :games, :high_budget_max_operator, :decimal, :default => 5000, :scale => 0, :precision => 15
    change_column :games, :high_budget_cap_operator, :integer, :default => 40
    change_column :games, :low_luxury_min_operator, :decimal, :default => 10000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_max_operator, :decimal, :default => 20000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_cap_operator, :integer, :default => 10
    change_column :games, :high_luxury_min_operator, :decimal, :default => 50000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_max_operator, :decimal, :default => 100000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_cap_operator, :integer, :default => 5
    change_column :games, :low_budget_var_max_operator, :decimal, :default => 20000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_var_max_operator, :decimal, :default => 30000, :scale => 0, :precision => 15
    change_column :games, :high_budget_var_max_operator, :decimal, :default => 50000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_var_max_operator, :decimal, :default => 80000, :scale => 0, :precision => 15
    change_column :games, :low_budget_var_min_operator, :decimal, :default => 10000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_var_min_operator, :decimal, :default => 15000, :scale => 0, :precision => 15
    change_column :games, :high_budget_var_min_operator, :decimal, :default => 20000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_var_min_operator, :decimal, :default => 30000, :scale => 0, :precision => 15

    change_column :games, :low_budget_min_customer, :decimal, :default => 1000, :scale => 0, :precision => 15
    change_column :games, :low_budget_max_customer, :decimal, :default => 2000, :scale => 0, :precision => 15
    change_column :games, :low_budget_cap_customer, :integer, :default => 20
    change_column :games, :high_budget_min_customer, :decimal, :default => 3000, :scale => 0, :precision => 15
    change_column :games, :high_budget_max_customer, :decimal, :default => 5000, :scale => 0, :precision => 15
    change_column :games, :high_budget_cap_customer, :integer, :default => 40
    change_column :games, :low_luxury_min_customer, :decimal, :default => 10000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_max_customer, :decimal, :default => 20000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_cap_customer, :integer, :default => 10
    change_column :games, :high_luxury_min_customer, :decimal, :default => 50000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_max_customer, :decimal, :default => 100000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_cap_customer, :integer, :default => 5
    change_column :games, :low_budget_var_max_customer, :decimal, :default => 20000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_var_max_customer, :decimal, :default => 30000, :scale => 0, :precision => 15
    change_column :games, :high_budget_var_max_customer, :decimal, :default => 50000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_var_max_customer, :decimal, :default => 80000, :scale => 0, :precision => 15
    change_column :games, :low_budget_var_min_customer, :decimal, :default => 10000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_var_min_customer, :decimal, :default => 15000, :scale => 0, :precision => 15
    change_column :games, :high_budget_var_min_customer, :decimal, :default => 20000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_var_min_customer, :decimal, :default => 30000, :scale => 0, :precision => 15

    change_column :games, :low_budget_min_tech, :decimal, :default => 1000, :scale => 0, :precision => 15
    change_column :games, :low_budget_max_tech, :decimal, :default => 2000, :scale => 0, :precision => 15
    change_column :games, :low_budget_cap_tech, :integer, :default => 20
    change_column :games, :high_budget_min_tech, :decimal, :default => 3000, :scale => 0, :precision => 15
    change_column :games, :high_budget_max_tech, :decimal, :default => 5000, :scale => 0, :precision => 15
    change_column :games, :high_budget_cap_tech, :integer, :default => 40
    change_column :games, :low_luxury_min_tech, :decimal, :default => 10000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_max_tech, :decimal, :default => 20000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_cap_tech, :integer, :default => 10
    change_column :games, :high_luxury_min_tech, :decimal, :default => 50000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_max_tech, :decimal, :default => 100000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_cap_tech, :integer, :default => 5
    change_column :games, :low_budget_var_max_tech, :decimal, :default => 20000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_var_max_tech, :decimal, :default => 30000, :scale => 0, :precision => 15
    change_column :games, :high_budget_var_max_tech, :decimal, :default => 50000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_var_max_tech, :decimal, :default => 80000, :scale => 0, :precision => 15
    change_column :games, :low_budget_var_min_tech, :decimal, :default => 10000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_var_min_tech, :decimal, :default => 15000, :scale => 0, :precision => 15
    change_column :games, :high_budget_var_min_tech, :decimal, :default => 20000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_var_min_tech, :decimal, :default => 30000, :scale => 0, :precision => 15

    change_column :games, :low_budget_min_supply, :decimal, :default => 1000, :scale => 0, :precision => 15
    change_column :games, :low_budget_max_supply, :decimal, :default => 2000, :scale => 0, :precision => 15
    change_column :games, :low_budget_cap_supply, :integer, :default => 20
    change_column :games, :high_budget_min_supply, :decimal, :default => 3000, :scale => 0, :precision => 15
    change_column :games, :high_budget_max_supply, :decimal, :default => 5000, :scale => 0, :precision => 15
    change_column :games, :high_budget_cap_supply, :integer, :default => 40
    change_column :games, :low_luxury_min_supply, :decimal, :default => 10000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_max_supply, :decimal, :default => 20000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_cap_supply, :integer, :default => 10
    change_column :games, :high_luxury_min_supply, :decimal, :default => 50000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_max_supply, :decimal, :default => 100000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_cap_supply, :integer, :default => 5
    change_column :games, :low_budget_var_max_supply, :decimal, :default => 20000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_var_max_supply, :decimal, :default => 30000, :scale => 0, :precision => 15
    change_column :games, :high_budget_var_max_supply, :decimal, :default => 50000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_var_max_supply, :decimal, :default => 80000, :scale => 0, :precision => 15
    change_column :games, :low_budget_var_min_supply, :decimal, :default => 10000, :scale => 0, :precision => 15
    change_column :games, :low_luxury_var_min_supply, :decimal, :default => 15000, :scale => 0, :precision => 15
    change_column :games, :high_budget_var_min_supply, :decimal, :default => 20000, :scale => 0, :precision => 15
    change_column :games, :high_luxury_var_min_supply, :decimal, :default => 30000, :scale => 0, :precision => 15


    change_column :markets, :lb_sweet_price, :decimal, :default => 0, :scale => 0, :precision => 15
    change_column :markets, :lb_max_price, :decimal, :default => 0, :scale => 0, :precision => 15
    change_column :markets, :hb_sweet_price, :decimal, :default => 0, :scale => 0, :precision => 15
    change_column :markets, :hb_max_price, :decimal, :default => 0, :scale => 0, :precision => 15
    change_column :markets, :ll_sweet_price, :decimal, :default => 0, :scale => 0, :precision => 15
    change_column :markets, :ll_max_price, :decimal, :default => 0, :scale => 0, :precision => 15
    change_column :markets, :hl_sweet_price, :decimal, :default => 0, :scale => 0, :precision => 15
    change_column :markets, :hl_max_price, :decimal, :default => 0, :scale => 0, :precision => 15
  end

  def down

    change_column :games, :low_budget_min_operator, :decimal, :default => 1000
    change_column :games, :low_budget_max_operator, :decimal, :default => 2000
    change_column :games, :low_budget_cap_operator, :integer, :default => 20
    change_column :games, :high_budget_min_operator, :decimal, :default => 3000
    change_column :games, :high_budget_max_operator, :decimal, :default => 5000
    change_column :games, :high_budget_cap_operator, :integer, :default => 40
    change_column :games, :low_luxury_min_operator, :decimal, :default => 10000
    change_column :games, :low_luxury_max_operator, :decimal, :default => 20000
    change_column :games, :low_luxury_cap_operator, :integer, :default => 10
    change_column :games, :high_luxury_min_operator, :decimal, :default => 50000
    change_column :games, :high_luxury_max_operator, :decimal, :default => 100000
    change_column :games, :high_luxury_cap_operator, :integer, :default => 5
    change_column :games, :low_budget_var_max_operator, :decimal, :default => 20000
    change_column :games, :low_luxury_var_max_operator, :decimal, :default => 30000
    change_column :games, :high_budget_var_max_operator, :decimal, :default => 50000
    change_column :games, :high_luxury_var_max_operator, :decimal, :default => 80000
    change_column :games, :low_budget_var_min_operator, :decimal, :default => 10000
    change_column :games, :low_luxury_var_min_operator, :decimal, :default => 15000
    change_column :games, :high_budget_var_min_operator, :decimal, :default => 20000
    change_column :games, :high_luxury_var_min_operator, :decimal, :default => 30000

    change_column :games, :low_budget_min_customer, :decimal, :default => 1000
    change_column :games, :low_budget_max_customer, :decimal, :default => 2000
    change_column :games, :low_budget_cap_customer, :integer, :default => 20
    change_column :games, :high_budget_min_customer, :decimal, :default => 3000
    change_column :games, :high_budget_max_customer, :decimal, :default => 5000
    change_column :games, :high_budget_cap_customer, :integer, :default => 40
    change_column :games, :low_luxury_min_customer, :decimal, :default => 10000
    change_column :games, :low_luxury_max_customer, :decimal, :default => 20000
    change_column :games, :low_luxury_cap_customer, :integer, :default => 10
    change_column :games, :high_luxury_min_customer, :decimal, :default => 50000
    change_column :games, :high_luxury_max_customer, :decimal, :default => 100000
    change_column :games, :high_luxury_cap_customer, :integer, :default => 5
    change_column :games, :low_budget_var_max_customer, :decimal, :default => 20000
    change_column :games, :low_luxury_var_max_customer, :decimal, :default => 30000
    change_column :games, :high_budget_var_max_customer, :decimal, :default => 50000
    change_column :games, :high_luxury_var_max_customer, :decimal, :default => 80000
    change_column :games, :low_budget_var_min_customer, :decimal, :default => 10000
    change_column :games, :low_luxury_var_min_customer, :decimal, :default => 15000
    change_column :games, :high_budget_var_min_customer, :decimal, :default => 20000
    change_column :games, :high_luxury_var_min_customer, :decimal, :default => 30000

    change_column :games, :low_budget_min_tech, :decimal, :default => 1000
    change_column :games, :low_budget_max_tech, :decimal, :default => 2000
    change_column :games, :low_budget_cap_tech, :integer, :default => 20
    change_column :games, :high_budget_min_tech, :decimal, :default => 3000
    change_column :games, :high_budget_max_tech, :decimal, :default => 5000
    change_column :games, :high_budget_cap_tech, :integer, :default => 40
    change_column :games, :low_luxury_min_tech, :decimal, :default => 10000
    change_column :games, :low_luxury_max_tech, :decimal, :default => 20000
    change_column :games, :low_luxury_cap_tech, :integer, :default => 10
    change_column :games, :high_luxury_min_tech, :decimal, :default => 50000
    change_column :games, :high_luxury_max_tech, :decimal, :default => 100000
    change_column :games, :high_luxury_cap_tech, :integer, :default => 5
    change_column :games, :low_budget_var_max_tech, :decimal, :default => 20000
    change_column :games, :low_luxury_var_max_tech, :decimal, :default => 30000
    change_column :games, :high_budget_var_max_tech, :decimal, :default => 50000
    change_column :games, :high_luxury_var_max_tech, :decimal, :default => 80000
    change_column :games, :low_budget_var_min_tech, :decimal, :default => 10000
    change_column :games, :low_luxury_var_min_tech, :decimal, :default => 15000
    change_column :games, :high_budget_var_min_tech, :decimal, :default => 20000
    change_column :games, :high_luxury_var_min_tech, :decimal, :default => 30000

    change_column :games, :low_budget_min_supply, :decimal, :default => 1000
    change_column :games, :low_budget_max_supply, :decimal, :default => 2000
    change_column :games, :low_budget_cap_supply, :integer, :default => 20
    change_column :games, :high_budget_min_supply, :decimal, :default => 3000
    change_column :games, :high_budget_max_supply, :decimal, :default => 5000
    change_column :games, :high_budget_cap_supply, :integer, :default => 40
    change_column :games, :low_luxury_min_supply, :decimal, :default => 10000
    change_column :games, :low_luxury_max_supply, :decimal, :default => 20000
    change_column :games, :low_luxury_cap_supply, :integer, :default => 10
    change_column :games, :high_luxury_min_supply, :decimal, :default => 50000
    change_column :games, :high_luxury_max_supply, :decimal, :default => 100000
    change_column :games, :high_luxury_cap_supply, :integer, :default => 5
    change_column :games, :low_budget_var_max_supply, :decimal, :default => 20000
    change_column :games, :low_luxury_var_max_supply, :decimal, :default => 30000
    change_column :games, :high_budget_var_max_supply, :decimal, :default => 50000
    change_column :games, :high_luxury_var_max_supply, :decimal, :default => 80000
    change_column :games, :low_budget_var_min_supply, :decimal, :default => 10000
    change_column :games, :low_luxury_var_min_supply, :decimal, :default => 15000
    change_column :games, :high_budget_var_min_supply, :decimal, :default => 20000
    change_column :games, :high_luxury_var_min_supply, :decimal, :default => 30000

    change_column :markets, :lb_sweet_price, :decimal, :default => 0
    change_column :markets, :lb_max_price, :decimal, :default => 0
    change_column :markets, :hb_sweet_price, :decimal, :default => 0
    change_column :markets, :hb_max_price, :decimal, :default => 0
    change_column :markets, :ll_sweet_price, :decimal, :default => 0
    change_column :markets, :ll_max_price, :decimal, :default => 0
    change_column :markets, :hl_sweet_price, :decimal, :default => 0
    change_column :markets, :hl_max_price, :decimal, :default => 0
  end

end
