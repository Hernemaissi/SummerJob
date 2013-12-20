class AddBreakCostToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :break_cost, :integer, :default => 0
  end
end
