class AddRiskMitigationToNetworks < ActiveRecord::Migration
  def change
    add_column :networks, :risk_mitigation, :integer, :default => 0
  end
end
