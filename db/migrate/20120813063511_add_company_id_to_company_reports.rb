class AddCompanyIdToCompanyReports < ActiveRecord::Migration
  def change
    add_column :company_reports, :company_id, :integer
  end
end
