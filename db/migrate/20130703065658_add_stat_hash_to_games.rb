class AddStatHashToGames < ActiveRecord::Migration
  def change
    add_column :games, :stat_hash, :text
  end
end
