class AddReadToRevisions < ActiveRecord::Migration
  def change
    add_column :revisions, :read, :boolean, :default => true
  end
end
