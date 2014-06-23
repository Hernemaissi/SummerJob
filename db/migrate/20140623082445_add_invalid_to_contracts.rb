class AddInvalidToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :void, :boolean, :default => false
  end
end
