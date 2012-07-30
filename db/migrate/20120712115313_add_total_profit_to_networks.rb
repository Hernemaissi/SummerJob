class AddTotalProfitToNetworks < ActiveRecord::Migration
  def change
    add_column :networks, :total_profit, :decimal, :precision => 20, :scale => 2, :default => 0.0
  end
end
