class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :capacity_name
      t.string :experience_name

      t.timestamps
    end
  end
end
