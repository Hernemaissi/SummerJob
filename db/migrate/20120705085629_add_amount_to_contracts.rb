class AddAmountToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :new_amount, :integer
    add_column :contracts, :new_service_level, :integer
    add_column :contracts, :under_negotiation, :boolean, :default => false
  end
end
