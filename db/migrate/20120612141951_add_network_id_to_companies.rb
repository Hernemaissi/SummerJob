class AddNetworkIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :network_id, :integer
  end
end
