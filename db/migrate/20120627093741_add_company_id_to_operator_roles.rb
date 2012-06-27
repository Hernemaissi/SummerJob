class AddCompanyIdToOperatorRoles < ActiveRecord::Migration
  def change
    add_column :operator_roles, :company_id, :integer
  end
end
