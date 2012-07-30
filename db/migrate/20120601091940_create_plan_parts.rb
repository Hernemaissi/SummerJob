class CreatePlanParts < ActiveRecord::Migration
  def change
    create_table :plan_parts do |t|
      t.string :title
      t.text :content
      t.boolean :ready, :default => false

      t.timestamps
    end
  end
end
