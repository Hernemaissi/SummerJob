class CreateContractProcesses < ActiveRecord::Migration
  def change
    create_table :contract_processes do |t|
      t.integer :initiator_id
      t.integer :receiver_id

      t.timestamps
    end
  end
end
