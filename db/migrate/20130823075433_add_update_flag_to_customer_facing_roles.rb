class AddUpdateFlagToCustomerFacingRoles < ActiveRecord::Migration
  def change
    add_column :customer_facing_roles, :update_flag, :boolean, :default => false
  end
end
