class AddValuesDecidedToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :values_decided, :boolean, :default => false
  end
end
