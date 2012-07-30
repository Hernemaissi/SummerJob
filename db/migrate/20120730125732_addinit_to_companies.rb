class AddinitToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :initialised, :boolean, :default => false
  end
end
