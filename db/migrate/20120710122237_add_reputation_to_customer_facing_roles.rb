class AddReputationToCustomerFacingRoles < ActiveRecord::Migration
  def change
    add_column :customer_facing_roles, :reputation, :integer, :default => 100
  end
end
