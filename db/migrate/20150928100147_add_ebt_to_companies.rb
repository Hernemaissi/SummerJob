class AddEbtToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :ebt, :decimal, precision: 20, scale: 2, default: 0.0
  end
end
