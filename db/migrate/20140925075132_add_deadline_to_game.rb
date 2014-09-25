class AddDeadlineToGame < ActiveRecord::Migration
  def change
    add_column :games, :deadline, :datetime
  end
end
