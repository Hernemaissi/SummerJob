class AddServiceTypeToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :service_type, :string
  end
end
