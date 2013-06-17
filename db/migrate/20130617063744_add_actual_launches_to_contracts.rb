class AddActualLaunchesToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :actual_launches, :integer
  end
end
