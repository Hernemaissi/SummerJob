class CreateNetworkReports < ActiveRecord::Migration
  def change
    create_table :network_reports do |t|
      t.integer :year
      t.integer :sales
      t.integer :realized_level
      t.integer :promised_level
      t.decimal :customer_revenue
      t.decimal :satisfaction
      t.integer :network_id

      t.timestamps
    end
  end
end
