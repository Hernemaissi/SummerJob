class AddStudentModeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :student_mode, :boolean, :default => false
  end
end
