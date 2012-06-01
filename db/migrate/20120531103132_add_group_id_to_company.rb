class AddGroupIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :group_id, :integer
  end
end
