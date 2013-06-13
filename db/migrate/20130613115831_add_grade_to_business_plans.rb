class AddGradeToBusinessPlans < ActiveRecord::Migration
  def change
    add_column :business_plans, :grade, :integer
  end
end
