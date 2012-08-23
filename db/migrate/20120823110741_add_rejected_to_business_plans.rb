class AddRejectedToBusinessPlans < ActiveRecord::Migration
  def change
    add_column :business_plans, :rejected, :boolean
    add_column :business_plans, :reject_message, :text
  end
end
