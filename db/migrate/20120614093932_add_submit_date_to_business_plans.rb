class AddSubmitDateToBusinessPlans < ActiveRecord::Migration
  def change
    add_column :business_plans, :submit_date, :datetime
  end
end
