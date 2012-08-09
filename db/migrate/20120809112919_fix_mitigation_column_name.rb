class FixMitigationColumnName < ActiveRecord::Migration
  def change
    rename_column :companies, :risk_migitation, :risk_mitigation
  end
end
