class AddTotalCustomersToGames < ActiveRecord::Migration
  def change
    add_column :games, :total_customers, :integer, :default => 0
    add_column :games, :currently_handled_customers, :integer, :default => 0
  end
end
