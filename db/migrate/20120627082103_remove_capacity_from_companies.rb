class RemoveCapacityFromCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :capacity
    remove_column :companies, :max_capacity
    remove_column :companies, :quality
    remove_column :companies, :max_quality
    remove_column :companies, :penetration
    remove_column :companies, :max_penetration
    remove_column :companies, :size
      end

  def down
    add_column :companies, :capacity, :integer
    add_column :companies, :max_capacity, :integer
    add_column :companies, :quality, :integer
    add_column :companies, :max_quality, :integer
    add_column :companies, :penetration, :integer
    add_column :companies, :max_penetration, :integer
    add_column :companies, :size, :integer
  end
end
