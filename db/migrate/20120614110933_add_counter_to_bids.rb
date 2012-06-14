class AddCounterToBids < ActiveRecord::Migration
  def change
    add_column :bids, :counter, :boolean
  end
end
