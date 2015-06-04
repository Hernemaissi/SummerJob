class AddLoanValuesToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :interest, :integer
    add_column :markets, :payback_per, :integer
  end
end
