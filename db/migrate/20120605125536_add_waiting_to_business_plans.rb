class AddWaitingToBusinessPlans < ActiveRecord::Migration
  def change
    add_column :business_plans, :waiting, :boolean, :default => false
    add_column :business_plans, :verified, :boolean, :default => false
  end
end
