class AddLimitHashToCompanyTypes < ActiveRecord::Migration
  def change
    add_column :company_types, :limit_hash, :text
  end
end
