class AddServiceProvidedToBids < ActiveRecord::Migration
  def change
    add_column :bids, :service_provided, :integer
    remove_column :bids, :offer
    add_column :bids, :offer, :string
  end
end
