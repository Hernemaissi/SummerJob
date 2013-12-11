class AddImageToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :image, :string
  end
end
