class AddCompanyIdToCustomerFacingRoles < ActiveRecord::Migration
  def change
    add_column :customer_facing_roles, :company_id, :integer
  end
end
