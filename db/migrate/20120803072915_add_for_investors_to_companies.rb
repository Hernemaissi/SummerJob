class AddForInvestorsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :for_investors, :text
  end
end
