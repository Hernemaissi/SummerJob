class AddReadOnlyToGames < ActiveRecord::Migration
  def change
    add_column :games, :read_only, :boolean, :default => false
  end
end
