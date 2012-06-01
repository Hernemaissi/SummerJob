class AddBusinessPlanIdToPlanParts < ActiveRecord::Migration
  def change
    add_column :plan_parts, :business_plan_id, :integer
  end
end
