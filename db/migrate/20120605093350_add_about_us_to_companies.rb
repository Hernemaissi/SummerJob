class AddAboutUsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :about_us, :string
  end
end
