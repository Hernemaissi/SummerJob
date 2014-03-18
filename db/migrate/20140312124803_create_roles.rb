class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :sell_price
      t.integer :service_level
      t.integer :product_type
      t.integer :market_id
      t.integer :company_id
      t.integer :sales_made, :default => 0
      t.decimal :last_satisfaction
      t.integer :number_of_units, :default => 0
      t.integer :unit_size, :default => 0
      t.integer :experience, :default => 0
      t.integer :marketing, :default => 0

      t.timestamps
    end
  end
end
