class AddSizeToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :size, :integer
  end
end
