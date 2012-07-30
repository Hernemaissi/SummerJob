class AddServiceProvidedToBids < ActiveRecord::Migration
  def change
    add_column :bids, :service_provided, :integer
    add_column :bids, :offer, :string
  end
end
