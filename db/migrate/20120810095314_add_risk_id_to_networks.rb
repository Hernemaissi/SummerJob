class AddRiskIdToNetworks < ActiveRecord::Migration
  def change
    add_column :networks, :risk_id, :integer
  end
end
