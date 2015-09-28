class AddOfficeToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :office, :text
  end
end
