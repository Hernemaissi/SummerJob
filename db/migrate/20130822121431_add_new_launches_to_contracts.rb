class AddNewLaunchesToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :new_launches, :integer
  end
end
