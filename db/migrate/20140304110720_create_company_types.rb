class CreateCompanyTypes < ActiveRecord::Migration
  def change
    create_table :company_types do |t|
      t.boolean :capacity_need
      t.boolean :capacity_produce
      t.integer :capacity
      t.boolean :experience_need
      t.boolean :experience_produce
      t.integer :experience
      t.boolean :unit_need
      t.boolean :unit_produce
      t.integer :unit

      t.timestamps
    end
  end
end
