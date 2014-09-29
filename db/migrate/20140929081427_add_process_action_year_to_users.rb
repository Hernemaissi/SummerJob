class AddProcessActionYearToUsers < ActiveRecord::Migration
  def change
    add_column :users, :process_action_year, :integer
  end
end
