class AddLaunchesToCompanyReports < ActiveRecord::Migration
  def change
    add_column :company_reports, :launches, :integer
  end
end
