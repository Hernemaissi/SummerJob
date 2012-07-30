class AddAboutUsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :about_us, :text
  end
end
