class CreateCustomerFacingRoles < ActiveRecord::Migration
  def change
    create_table :customer_facing_roles do |t|
      t.integer :sell_price
      t.integer :promised_service_level

      t.timestamps
    end
  end
end
