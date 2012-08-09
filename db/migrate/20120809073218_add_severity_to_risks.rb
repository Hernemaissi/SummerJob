class AddSeverityToRisks < ActiveRecord::Migration
  def change
    add_column :risks, :severity, :integer, :default => 1
  end
end
