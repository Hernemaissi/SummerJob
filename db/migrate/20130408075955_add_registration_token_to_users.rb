class AddRegistrationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :registration_token, :string
  end
end
