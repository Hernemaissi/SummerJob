class AddReceiverAndSenderToBids < ActiveRecord::Migration
  def change
    add_column :bids, :receiver_id, :integer
    add_column :bids, :sender_id, :integer
  end
end
