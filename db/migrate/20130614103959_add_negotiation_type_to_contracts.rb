class AddNegotiationTypeToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :negotiation_type, :string
  end
end
