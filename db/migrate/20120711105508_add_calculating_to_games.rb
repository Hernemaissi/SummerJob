class AddCalculatingToGames < ActiveRecord::Migration
  def change
    add_column :games, :calculating, :boolean, :default => false
  end
end
