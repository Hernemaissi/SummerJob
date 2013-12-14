class AddShowReadEventsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :show_read_events, :boolean, :default => true
  end
end
