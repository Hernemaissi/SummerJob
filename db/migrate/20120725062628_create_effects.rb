class CreateEffects < ActiveRecord::Migration
  def change
    create_table :effects do |t|
      t.string :name
      t.string :description
      t.integer :level_change
      t.integer :type_change
      t.integer :value_change
      t.integer :fluctuation_change

      t.timestamps
    end
  end
end
