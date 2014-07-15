class AddShowReadEventsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :show_read_events, :boolean, :default => true
  end
end
