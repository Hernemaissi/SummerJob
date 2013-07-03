class AddStatHashToGames < ActiveRecord::Migration
  def change
    add_column :games, :variable_hash, :text
  end
end
