class AddRemainingDurationToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :remaining, :integer
  end
end
