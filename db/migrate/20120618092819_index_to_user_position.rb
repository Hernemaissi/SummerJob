class IndexToUserPosition < ActiveRecord::Migration
  def change
    add_index :users, :position
  end
end
