class AddSegmentPropertiesToMarket < ActiveRecord::Migration
  def change
    add_column :markets, :lb_amount, :integer, :default => 0
    add_column :markets, :lb_sweet_price, :decimal, :default => 0
    add_column :markets, :lb_max_price, :decimal, :default => 0
    add_column :markets, :hb_amount, :integer, :default => 0
    add_column :markets, :hb_sweet_price, :decimal, :default => 0
    add_column :markets, :hb_max_price, :decimal, :default => 0
    add_column :markets, :ll_amount, :integer, :default => 0
    add_column :markets, :ll_sweet_price, :decimal, :default => 0
    add_column :markets, :ll_max_price, :decimal, :default => 0
    add_column :markets, :hl_amount, :integer, :default => 0
    add_column :markets, :hl_sweet_price, :decimal, :default => 0
    add_column :markets, :hl_max_price, :decimal, :default => 0
  end
end
