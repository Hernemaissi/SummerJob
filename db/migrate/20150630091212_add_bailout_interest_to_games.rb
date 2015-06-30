class AddBailoutInterestToGames < ActiveRecord::Migration
  def change
    add_column :games, :bailout_interest, :integer, default: 25
  end
end
