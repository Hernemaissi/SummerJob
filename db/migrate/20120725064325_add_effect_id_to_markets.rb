class AddEffectIdToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :effect_id, :integer
  end
end
