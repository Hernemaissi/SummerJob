class RemoveParametersFromCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :number_of_units
    remove_column :companies, :unit_size
    remove_column :companies, :experience
    remove_column :companies, :marketing
  end

  def down
    add_column :companies, :marketing, :integer
    add_column :companies, :experience, :integer
    add_column :companies, :unit_size, :integer
    add_column :companies, :number_of_units, :integer
  end
end
