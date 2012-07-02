class AddProductTypeToOperatorRoles < ActiveRecord::Migration
  def change
    add_column :operator_roles, :product_type, :integer, :default => 1
  end
end
