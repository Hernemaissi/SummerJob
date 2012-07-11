class AddBelongsToNetworkToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :belongs_to_network, :boolean, :default => false
  end
end
