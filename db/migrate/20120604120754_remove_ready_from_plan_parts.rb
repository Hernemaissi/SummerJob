class RemoveReadyFromPlanParts < ActiveRecord::Migration
  def up
    remove_column :plan_parts, :ready
  end

  def down
  end
end
