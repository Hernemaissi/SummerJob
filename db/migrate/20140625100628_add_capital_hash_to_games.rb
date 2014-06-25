class AddCapitalHashToGames < ActiveRecord::Migration
  def change
    add_column :games, :capital_hash, :text
  end
end
