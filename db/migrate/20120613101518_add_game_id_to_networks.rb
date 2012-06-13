class AddGameIdToNetworks < ActiveRecord::Migration
  def change
    add_column :networks, :game_id, :integer
  end
end
