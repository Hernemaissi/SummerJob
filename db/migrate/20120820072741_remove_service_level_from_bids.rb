class RemoveServiceLevelFromBids < ActiveRecord::Migration
  def up
    remove_column :bids, :service_level
      end

  def down
    add_column :bids, :service_level, :integer
  end
end
