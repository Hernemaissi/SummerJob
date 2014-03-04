class DropCapacity < ActiveRecord::Migration
  def up
    drop_table :capacities
  end

  def down
    create_table :capacities do |t|
      t.string :name

      t.timestamps
    end
  end
end
