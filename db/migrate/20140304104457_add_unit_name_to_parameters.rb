class AddUnitNameToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :unit_name, :string
  end
end
