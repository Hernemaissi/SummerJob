class AddMaxCapacityAndCapacityCostToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :max_capacity, :integer, :default => 0
    add_column :companies, :capacity_cost, :decimal, :precision => 20, :scale => 2, :default => 0.0
  end
end
