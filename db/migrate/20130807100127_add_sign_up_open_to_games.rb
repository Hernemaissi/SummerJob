class AddSignUpOpenToGames < ActiveRecord::Migration
  def change
    add_column :games, :sign_up_open, :boolean, :default => true
  end
end
