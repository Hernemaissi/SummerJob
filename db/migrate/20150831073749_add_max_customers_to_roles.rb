class AddMaxCustomersToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :max_customers, :integer
  end
end
