class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.decimal :fixedCost, :precision => 5, :scale => 2, :default => 0.0
      t.decimal :variableCost, :precision => 5, :scale => 2, :default => 0.0
      t.decimal :revenue, :precision => 5, :scale => 2, :default => 0.0
      t.decimal :profit, :precision => 5, :scale => 2, :default => 0.0

      t.timestamps
    end
  end
end
