class AddMaxSubRoundsToGames < ActiveRecord::Migration
  def change
    add_column :games, :max_sub_rounds, :integer, default: 4
  end
end
