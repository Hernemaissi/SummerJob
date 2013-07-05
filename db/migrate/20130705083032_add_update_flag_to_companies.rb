class AddUpdateFlagToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :update_flag, :boolean, :default => false
  end
end
