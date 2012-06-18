class AddPositionToPlanParts < ActiveRecord::Migration
  def change
    add_column :plan_parts, :position, :string
  end
end
