class CreateServiceRoles < ActiveRecord::Migration
  def change
    create_table :service_roles do |t|
      t.integer :service_level
      t.boolean :specialized
      t.string :type

      t.timestamps
    end
  end
end
