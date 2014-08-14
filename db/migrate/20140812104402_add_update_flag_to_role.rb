class AddUpdateFlagToRole < ActiveRecord::Migration
  def change
    add_column :roles, :update_flag, :boolean
  end
end
