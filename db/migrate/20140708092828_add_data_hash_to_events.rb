class AddDataHashToEvents < ActiveRecord::Migration
  def change
    add_column :events, :data_hash, :text
  end
end
