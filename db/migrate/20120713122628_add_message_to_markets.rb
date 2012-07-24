class AddMessageToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :message, :string
  end
end
