class AddReadToEvents < ActiveRecord::Migration
  def change
    add_column :events, :read, :boolean, :default => false
  end
end
