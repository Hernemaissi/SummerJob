class AddBelongsToNetworkToCustomerFacingRoles < ActiveRecord::Migration
  def change
    add_column :customer_facing_roles, :belongs_to_network, :boolean, :default => false
  end
end
