class AddContractProcessIdToBids < ActiveRecord::Migration
  def change
    add_column :bids, :contract_process_id, :integer
  end
end
