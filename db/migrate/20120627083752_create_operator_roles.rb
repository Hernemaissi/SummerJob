class CreateOperatorRoles < ActiveRecord::Migration
  def change
    create_table :operator_roles do |t|
      t.integer :service_level
      t.boolean :specialized

      t.timestamps
    end
  end
end
