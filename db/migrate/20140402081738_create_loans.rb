class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.decimal :loan_amount
      t.integer :interest
      t.integer :duration

      t.timestamps
    end
  end
end
