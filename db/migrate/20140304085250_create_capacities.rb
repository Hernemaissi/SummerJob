class CreateCapacities < ActiveRecord::Migration
  def change
    create_table :capacities do |t|
      t.string :name

      t.timestamps
    end
  end
end
