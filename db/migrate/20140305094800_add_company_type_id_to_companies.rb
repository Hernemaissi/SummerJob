class AddCompanyTypeIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :company_type_id, :integer
  end
end
