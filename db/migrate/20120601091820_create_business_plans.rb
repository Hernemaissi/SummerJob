class CreateBusinessPlans < ActiveRecord::Migration
  def change
    create_table :business_plans do |t|
      t.boolean :public, :default => false
      t.boolean :waiting, :default => false
      t.boolean :verified, :default => false

      t.timestamps
    end
  end
end
