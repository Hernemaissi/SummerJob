class AddCapacityToOperatorRoles < ActiveRecord::Migration
  def change
    add_column :operator_roles, :capacity, :integer, :default => 1
  end
end
