class AddSetupToGames < ActiveRecord::Migration
  def change
    add_column :games, :setup, :boolean, :default => false
  end
end
