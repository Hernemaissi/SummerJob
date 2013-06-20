class AddSalesMadeToCustomerFacingRoles < ActiveRecord::Migration
  def change
    add_column :customer_facing_roles, :sales_made, :integer, :default => 0
  end
end
