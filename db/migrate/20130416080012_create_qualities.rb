class CreateQualities < ActiveRecord::Migration
  def change
    create_table :qualities do |t|
      t.string :title
      t.text :description
      t.boolean :used, :default => true

      t.timestamps
    end
  end
end
