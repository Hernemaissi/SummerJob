class AddGradeAndFeedbackToRevisions < ActiveRecord::Migration
  def change
    add_column :revisions, :grade, :integer
    add_column :revisions, :feedback, :text
  end
end
