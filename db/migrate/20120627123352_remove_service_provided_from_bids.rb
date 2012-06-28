class RemoveServiceProvidedFromBids < ActiveRecord::Migration
  def up
    remove_column :bids, :service_provided
      end

  def down
    add_column :bids, :service_provided, :integer
  end
end
