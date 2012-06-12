class CreateNetworks < ActiveRecord::Migration
  def change
    create_table :networks do |t|

      t.timestamps
    end
  end
end
