class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.integer :company_id
      t.text :value_proposition
      t.text :revenue_streams
      t.text :cost_structure
      t.text :key_resources
      t.text :key_activities
      t.text :customer_segments
      t.text :key_partners
      t.text :channels
      t.text :customer_relationships

      t.timestamps
    end
  end
end
