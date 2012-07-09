class AddReadToBid < ActiveRecord::Migration
  def change
    add_column :bids, :read, :boolean, :default => false
  end
end
