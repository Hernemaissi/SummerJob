class AddTestToMultipleModels < ActiveRecord::Migration
  def change
    add_column :companies, :test, :boolean, :default => false
    add_column :groups, :test, :boolean, :default => false
    add_column :markets, :test, :boolean, :default => false
    add_column :users, :test, :boolean, :default => false
    add_column :roles, :test, :boolean, :default => false
  end
end
