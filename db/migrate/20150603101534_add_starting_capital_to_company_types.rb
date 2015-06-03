class AddStartingCapitalToCompanyTypes < ActiveRecord::Migration
  def change
    add_column :company_types, :starting_capital, :integer
  end
end
