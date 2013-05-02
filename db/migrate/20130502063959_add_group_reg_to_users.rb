class AddGroupRegToUsers < ActiveRecord::Migration
  def change
    add_column :users, :group_token, :string
    add_column :users, :group_registered, :boolean, :default => false
  end
end
