class CreateRisks < ActiveRecord::Migration
  def change
    create_table :risks do |t|
      t.string :title
      t.text :description
      t.integer :customer_return
      t.integer :penalty
      t.integer :possibility

      t.timestamps
    end
  end
end
