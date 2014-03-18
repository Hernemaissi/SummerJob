class AddPriceSetToCompanyTypes < ActiveRecord::Migration
  def change
    add_column :company_types, :price_set, :boolean
  end
end
