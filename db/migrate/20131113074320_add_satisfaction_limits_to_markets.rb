class AddSatisfactionLimitsToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :satisfaction_limits, :text
  end
end
