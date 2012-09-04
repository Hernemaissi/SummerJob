class AddMinMaxToGames < ActiveRecord::Migration
  def change
    add_column :games, :low_budget_min, :decimal, :default => 1000
    add_column :games, :low_budget_max, :decimal, :default => 2000
    add_column :games, :low_budget_cap, :integer, :default => 20
    add_column :games, :high_budget_min, :decimal, :default => 3000
    add_column :games, :high_budget_max, :decimal, :default => 5000
    add_column :games, :high_budget_cap, :integer, :default => 40
    add_column :games, :low_luxury_min, :decimal, :default => 10000
    add_column :games, :low_luxury_max, :decimal, :default => 20000
    add_column :games, :low_luxury_cap, :integer, :default => 10
    add_column :games, :high_luxury_min, :decimal, :default => 50000
    add_column :games, :high_luxury_max, :decimal, :default => 100000
    add_column :games, :high_luxury_cap, :integer, :default => 5
  end
end
