class AddInProgressToGames < ActiveRecord::Migration
  def change
    add_column :games, :in_progress, :boolean
  end
end
