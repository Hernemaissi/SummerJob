class RemoveAmountsFromCompanyTypes < ActiveRecord::Migration
  def up
    remove_column :company_types, :capacity
    remove_column :company_types, :experience
    remove_column :company_types, :unit
  end

  def down
    add_column :company_types, :unit, :integer
    add_column :company_types, :experience, :integer
    add_column :company_types, :capacity, :integer
  end
end
