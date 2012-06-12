class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.integer :service_provider_id
      t.integer :service_buyer_id
      t.integer :bid_id

      t.timestamps
    end
  end
end
