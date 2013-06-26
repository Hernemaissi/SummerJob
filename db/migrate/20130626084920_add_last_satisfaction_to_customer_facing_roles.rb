class AddLastSatisfactionToCustomerFacingRoles < ActiveRecord::Migration
  def change
    add_column :customer_facing_roles, :last_satisfaction, :decimal
  end
end
