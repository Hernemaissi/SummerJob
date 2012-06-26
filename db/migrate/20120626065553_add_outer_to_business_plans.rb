class AddOuterToBusinessPlans < ActiveRecord::Migration
  def change
    add_column :plan_parts, :outer, :boolean, :default => false
  end
end
