class AddImageToCompanyTypes < ActiveRecord::Migration
  def change
    add_column :company_types, :image, :string
  end
end
