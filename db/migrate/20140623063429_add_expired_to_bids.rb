class AddExpiredToBids < ActiveRecord::Migration
  def change
    add_column :bids, :expired, :boolean, :default => false
  end
end
