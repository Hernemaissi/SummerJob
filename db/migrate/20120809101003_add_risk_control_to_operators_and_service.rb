class AddRiskControlToOperatorsAndService < ActiveRecord::Migration
  def change
    add_column :companies, :risk_control_cost, :decimal, :precision => 20, :scale => 2, :default => 0.0
    add_column :companies, :risk_migitation, :integer, :default => 0
  end
end
