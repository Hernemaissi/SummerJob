class AddFixedSatCostToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :fixed_sat_cost, :decimal
  end
end
