class AddNegativeCapitalToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :negative_capital, :boolean, :default => false
  end
end
