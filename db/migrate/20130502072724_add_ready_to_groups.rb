class AddReadyToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :ready, :boolean, :default => false
  end
end
