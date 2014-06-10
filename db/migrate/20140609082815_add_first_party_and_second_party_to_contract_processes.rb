class AddFirstPartyAndSecondPartyToContractProcesses < ActiveRecord::Migration
  def change
    add_column :contract_processes, :first_party_id, :integer
    add_column :contract_processes, :second_party_id, :integer
  end
end
