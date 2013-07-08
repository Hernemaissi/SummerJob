class AddSubRoundAcceptedToGames < ActiveRecord::Migration
  def change
    add_column :games, :sub_round_decided, :boolean
  end
end
