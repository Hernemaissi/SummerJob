class AddParameterAmountsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :number_of_units, :integer, :default => 0
    add_column :companies, :unit_size, :integer, :default => 0
    add_column :companies, :experience, :integer, :default => 0
    add_column :companies, :marketing, :integer, :default => 0
  end
end
