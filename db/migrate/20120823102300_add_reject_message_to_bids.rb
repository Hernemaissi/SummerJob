class AddRejectMessageToBids < ActiveRecord::Migration
  def change
    add_column :bids, :reject_message, :text
  end
end
