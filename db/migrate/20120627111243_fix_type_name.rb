class FixTypeName < ActiveRecord::Migration
  def change
    rename_column :service_roles, :type, :service_type
  end
end
