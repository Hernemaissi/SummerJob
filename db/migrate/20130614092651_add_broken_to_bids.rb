class AddBrokenToBids < ActiveRecord::Migration
  def change
    add_column :bids, :broken, :boolean, :default => false
  end
end
