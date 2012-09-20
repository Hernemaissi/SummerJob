class AddProductTypeToOtherRoles < ActiveRecord::Migration
  def change
    add_column :service_roles, :product_type, :integer
    add_column :customer_facing_roles, :product_type, :integer
  end
end
