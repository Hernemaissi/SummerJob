class RenamePromisedServicelevel < ActiveRecord::Migration
  def change
    rename_column :customer_facing_role, :promised_service_level, :service_level
  end
end
