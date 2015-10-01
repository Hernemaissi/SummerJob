class AddCustomerAmountToReport < ActiveRecord::Migration
  def change
    add_column :company_reports, :customer_amount, :integer
  end
end
