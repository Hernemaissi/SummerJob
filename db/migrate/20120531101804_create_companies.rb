class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.decimal :fixedCost, :precision => 20, :scale => 2, :default => 0.0
      t.decimal :variableCost, :precision => 20, :scale => 2, :default => 0.0
      t.decimal :revenue, :precision => 20, :scale => 2, :default => 0.0
      t.decimal :profit, :precision => 20, :scale => 2, :default => 0.0

      t.timestamps
    end
  end
end
