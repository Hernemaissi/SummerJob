class AddEarlierChoiceToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :earlier_choice, :string
  end
end
