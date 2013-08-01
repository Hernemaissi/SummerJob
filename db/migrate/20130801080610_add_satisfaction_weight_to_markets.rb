class AddSatisfactionWeightToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :lb_satisfaction_weight, :decimal, :precision => 2, :scale => 1, :default => 0.0
    add_column :markets, :ll_satisfaction_weight, :decimal, :precision => 2, :scale => 1, :default => 0.0
    add_column :markets, :hb_satisfaction_weight, :decimal, :precision => 2, :scale => 1, :default => 0.0
    add_column :markets, :hl_satisfaction_weight, :decimal, :precision => 2, :scale => 1, :default => 0.0
  end
end
