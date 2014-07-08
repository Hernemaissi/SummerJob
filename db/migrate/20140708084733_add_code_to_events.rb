class AddCodeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :code, :integer
  end
end
