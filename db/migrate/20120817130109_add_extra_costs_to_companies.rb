class AddExtraCostsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :extra_costs, :decimal, :precision => 20, :scale => 2, :default => 0.0
  end
end
