class CreateUsersQualityvaluesJoin < ActiveRecord::Migration
  def up
    create_table :qualityvalues_users, :id => false do |t|
      t.integer :qualityvalue_id
      t.integer :user_id
    end

    add_index :qualityvalues_users, [:qualityvalue_id, :user_id]
  end

  def down
    drop_table :qualityvalues_users
  end
end
