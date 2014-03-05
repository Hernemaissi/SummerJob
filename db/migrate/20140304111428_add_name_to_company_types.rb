class AddNameToCompanyTypes < ActiveRecord::Migration
  def change
    add_column :company_types, :name, :string
  end
end
