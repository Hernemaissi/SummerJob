class AddCompanySatisfactionToCompanyReports < ActiveRecord::Migration
  def change
    add_column :company_reports, :satisfaction, :decimal
  end
end
