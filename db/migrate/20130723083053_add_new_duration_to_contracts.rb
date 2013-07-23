class AddNewDurationToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :new_duration, :integer
  end
end
