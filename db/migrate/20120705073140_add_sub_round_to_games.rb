class AddSubRoundToGames < ActiveRecord::Migration
  def change
    add_column :games, :sub_round, :integer, :default => 1
  end
end
