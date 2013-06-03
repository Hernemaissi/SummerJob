class AddOrderToQualities < ActiveRecord::Migration
  def change
    add_column :qualities, :order_number, :integer, :default => 1
  end
end
