class AddLaunchesMadeToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :launches_made, :integer, :default => 0
  end
end
