class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :current_round, :default => 1
      t.integer :max_rounds, :default => 3

      t.timestamps
    end
  end
end
