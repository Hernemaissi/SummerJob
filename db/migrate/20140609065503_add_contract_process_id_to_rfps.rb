class AddContractProcessIdToRfps < ActiveRecord::Migration
  def change
    add_column :rfps, :contract_process_id, :integer
  end
end
