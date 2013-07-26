class AddRisksToCustomerFacingRoles < ActiveRecord::Migration
  def change
    add_column :customer_facing_roles, :risk_id, :integer
  end
end
