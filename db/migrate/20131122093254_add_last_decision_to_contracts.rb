class AddLastDecisionToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :last_decision, :string
  end
end
