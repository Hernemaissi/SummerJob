class AddSatisfactionLevelsToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :min_satisfaction, :decimal, :default => 0.6
    add_column :markets, :expected_satisfaction, :decimal, :default => 0.8
    add_column :markets, :max_satisfaction_bonus, :decimal, :default => 1.2
  end
end
