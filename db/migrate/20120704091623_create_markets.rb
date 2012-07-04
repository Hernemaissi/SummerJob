class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string :name
      t.integer :customer_amount
      t.integer :preferred_type
      t.integer :preferred_level
      t.integer :base_price
      t.integer :price_buffer

      t.timestamps
    end
  end
end
