class AddCompanyIdToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :company_id, :integer
  end
end
