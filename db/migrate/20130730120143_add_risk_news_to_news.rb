class AddRiskNewsToNews < ActiveRecord::Migration
  def change
    add_column :news, :risk_content, :text
  end
end
