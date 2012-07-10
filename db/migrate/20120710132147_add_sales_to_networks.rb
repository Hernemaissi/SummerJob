class AddSalesToNetworks < ActiveRecord::Migration
  def change
    add_column :networks, :sales, :integer, :default => 0
    add_column :networks, :satisfaction, :decimal, :default => 0
  end
end
