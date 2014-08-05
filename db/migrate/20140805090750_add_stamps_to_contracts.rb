class AddStampsToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :stamps, :text
  end
end
