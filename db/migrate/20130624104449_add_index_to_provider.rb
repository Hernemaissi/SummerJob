class AddIndexToProvider < ActiveRecord::Migration
  def self.up
    add_index :contracts, :service_provider_id
  end

  def self.down
    remove_index :contracts, :service_provider_id
  end

end
