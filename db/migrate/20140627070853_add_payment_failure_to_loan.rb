class AddPaymentFailureToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :payment_failure, :boolean, :default => false
  end
end
