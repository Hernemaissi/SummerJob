class RemoveNewServiceLevelFromContracts < ActiveRecord::Migration
  def up
    remove_column :contracts, :new_service_level
      end

  def down
    add_column :contracts, :new_service_level, :integer
  end
end
