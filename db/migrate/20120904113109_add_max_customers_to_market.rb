class AddMaxCustomersToMarket < ActiveRecord::Migration
  def change
    add_column :markets, :lb_max_customers, :integer
    add_column :markets, :ll_max_customers, :integer
    add_column :markets, :hb_max_customers, :integer
    add_column :markets, :hl_max_customers, :integer
  end
end
