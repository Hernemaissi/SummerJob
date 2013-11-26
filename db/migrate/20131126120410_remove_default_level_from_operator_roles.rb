class RemoveDefaultLevelFromOperatorRoles < ActiveRecord::Migration
  def up
    change_column_default(:operator_roles, :product_type, nil)
  end

  def down
    change_column_default(:operator_roles, :product_type, 1)
  end

end
