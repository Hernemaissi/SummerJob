class CreateNeeds < ActiveRecord::Migration
  def change
    create_table :needs do |t|
      t.integer :needer_id
      t.integer :needed_id

      t.timestamps
    end
    
    add_index :needs, :needer_id
    add_index :needs, :needed_id
    add_index :needs, [:needer_id, :needed_id], unique: true
  end
end