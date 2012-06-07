class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :offer
      t.integer :amount
      t.string :message
      t.string :status
      t.integer :rfp_id

      t.timestamps
    end
  end
end
