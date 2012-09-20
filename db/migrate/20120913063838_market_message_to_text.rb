class MarketMessageToText < ActiveRecord::Migration
  def change
    remove_column :markets, :message
    add_column :markets, :message, :text
  end
end
