class AddSwitchingParametersToBids < ActiveRecord::Migration
  def change
    add_column :bids, :agreed_duration, :integer
    add_column :bids, :remaining_duration, :integer
    add_column :bids, :penalty, :decimal, :precision => 20, :scale => 2, :default => 0.0
    add_column :bids, :launches, :integer
  end
end
