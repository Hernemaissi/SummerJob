class RemoveCapitalsFromColumns < ActiveRecord::Migration
  def change
    rename_column :companies, :fixedCost, :fixed_cost
    rename_column :companies, :variableCost, :variable_cost
    rename_column :users, :studentNumber, :student_number
    rename_column :users, :isTeacher, :teacher
  end
end
