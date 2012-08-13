class CreateCompanyReports < ActiveRecord::Migration
  def change
    create_table :company_reports do |t|
      t.integer :year
      t.decimal :base_fixed_cost
      t.decimal :customer_revenue
      t.decimal :contract_revenue
      t.decimal :profit
      t.decimal :risk_control
      t.decimal :contract_cost
      t.decimal :variable_cost

      t.timestamps
    end
  end
end
