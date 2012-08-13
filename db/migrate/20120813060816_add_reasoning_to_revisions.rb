class AddReasoningToRevisions < ActiveRecord::Migration
  def change
    add_column :revisions, :reasoning, :text
  end
end
