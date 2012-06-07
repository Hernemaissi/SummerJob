class CreateRfps < ActiveRecord::Migration
  def change
    create_table :rfps do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :content

      t.timestamps
    end
    
    add_index :rfps, :sender_id
    add_index :rfps, :receiver_id
  end
end
