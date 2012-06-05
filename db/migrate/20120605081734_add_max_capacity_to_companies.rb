class AddMaxCapacityToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :max_capacity, :integer
    add_column :companies, :capacity, :integer, :default => 0
    add_column :companies, :max_quality, :integer
    add_column :companies, :quality, :integer, :default => 0
    add_column :companies, :penetration, :integer, :default => 0
    add_column :companies, :max_penetration, :integer
    add_column :companies, :service_type, :string
    add_column :companies, :initialised, :boolean, :default => false
  end
end
