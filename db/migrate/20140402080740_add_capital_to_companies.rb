class AddCapitalToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :capital, :decimal, :default => 0.0
  end
end
