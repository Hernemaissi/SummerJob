class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :headline
      t.string :picture_url
      t.text :content
      t.text :market_content

      t.timestamps
    end
  end
end
