class ChangeExperienceFormatInRole < ActiveRecord::Migration
  def up
    change_column :roles, :experience, :decimal
  end

  def down
    change_column :roles, :experience, :integer
  end
end
