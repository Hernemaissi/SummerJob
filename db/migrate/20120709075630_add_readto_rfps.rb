class AddReadtoRfps < ActiveRecord::Migration
  def up
    add_column :rfps, :read, :boolean, :default => false
  end

  def down
    remove_column :rfps, :read
  end
end
