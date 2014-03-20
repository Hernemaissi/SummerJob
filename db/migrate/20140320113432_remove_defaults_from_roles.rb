class RemoveDefaultsFromRoles < ActiveRecord::Migration
  def up
    change_column_default(:roles, :marketing, nil)
    change_column_default(:roles, :number_of_units, nil)
    change_column_default(:roles, :unit_size, nil)
    change_column_default(:roles, :experience, nil)
  end

  def down
    change_column_default(:roles, :marketing, 0)
    change_column_default(:roles, :number_of_units, 0)
    change_column_default(:roles, :unit_size, 0)
    change_column_default(:roles, :experience, 0)
    
  end
end
