class AddAssetsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :assets, :decimal, :precision => 5, :scale => 2, :default => 0.0
  end
end
