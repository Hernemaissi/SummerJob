class AddIndexToEffectNames < ActiveRecord::Migration
  def change
    add_index :effects, :name
  end
end
