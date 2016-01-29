class AddTestNameToCompanyTypes < ActiveRecord::Migration
  def change
    add_column :company_types, :test_name, :string
  end
end
