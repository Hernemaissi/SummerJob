class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :studentNumber
      t.string :department
      t.string :role
      t.boolean :isTeacher, :default => false

      t.timestamps
    end
  end
end
