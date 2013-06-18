class AddLaunchesMadeToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :launches_made, :integer, :default => 0
  end
end
