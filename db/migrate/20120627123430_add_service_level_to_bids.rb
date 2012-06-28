class AddServiceLevelToBids < ActiveRecord::Migration
  def change
    add_column :bids, :service_level, :integer
  end
end
