class AddCompanyIdToServiceRoles < ActiveRecord::Migration
  def change
    add_column :service_roles, :company_id, :integer
  end
end
