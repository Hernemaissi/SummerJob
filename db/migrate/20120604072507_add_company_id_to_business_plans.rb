class AddCompanyIdToBusinessPlans < ActiveRecord::Migration
  def change
    add_column :business_plans, :company_id, :integer
  end
end
