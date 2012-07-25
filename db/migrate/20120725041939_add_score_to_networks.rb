class AddScoreToNetworks < ActiveRecord::Migration
  def change
    add_column :networks, :score, :integer, :default => 0
  end
end
