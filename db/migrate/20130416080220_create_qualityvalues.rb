class CreateQualityvalues < ActiveRecord::Migration
  def change
    create_table :qualityvalues do |t|
      t.string :value
      t.integer :quality_id

      t.timestamps
    end
  end
end
