class AddCapitalBonusToCompanyTypes < ActiveRecord::Migration
  def change
    add_column :company_types, :capital_bonus, :text
  end
end
