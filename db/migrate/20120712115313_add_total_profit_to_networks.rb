class AddTotalProfitToNetworks < ActiveRecord::Migration
  def change
    add_column :networks, :total_profit, :decimal
  end
end
