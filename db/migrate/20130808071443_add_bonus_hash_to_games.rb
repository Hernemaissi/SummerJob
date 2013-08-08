class AddBonusHashToGames < ActiveRecord::Migration
  def change
    add_column :games, :bonus_hash, :text
  end
end
