class RemoveScoreFromNetworks < ActiveRecord::Migration
  def up
    remove_column :networks, :score
    add_column :networks, :score, :decimal, :default => 0.0
      end

  def down
    remove_column :networks, :score
    add_column :networks, :score, :integer, :default => 0
  end
end
