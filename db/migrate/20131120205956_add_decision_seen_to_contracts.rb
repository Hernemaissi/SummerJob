class AddDecisionSeenToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :decision_seen, :boolean, :default => true
  end
end
