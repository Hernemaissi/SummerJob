class AddMarketIdToCustomerFacingRoles < ActiveRecord::Migration
  def change
    add_column :customer_facing_roles, :market_id, :integer
  end
end
