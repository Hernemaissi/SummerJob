class AddResultsPublishedToGames < ActiveRecord::Migration
  def change
    add_column :games, :results_published, :boolean, :default => true
  end
end
