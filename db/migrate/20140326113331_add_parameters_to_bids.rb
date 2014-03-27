class AddParametersToBids < ActiveRecord::Migration
  def change
    add_column :bids, :marketing_amount, :integer
    add_column :bids, :experience_amount, :integer
    add_column :bids, :unit_amount, :integer
    add_column :bids, :capacity_amount, :integer
  end
end
