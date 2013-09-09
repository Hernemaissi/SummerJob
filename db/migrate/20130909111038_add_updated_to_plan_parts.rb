class AddUpdatedToPlanParts < ActiveRecord::Migration
  def change
    add_column :plan_parts, :updated, :boolean, :default => true
  end
end
