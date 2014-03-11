class AddMarketingToCompanyTypes < ActiveRecord::Migration
  def change
    add_column :company_types, :marketing_need, :boolean
    add_column :company_types, :marketing_produce, :boolean
  end
end
