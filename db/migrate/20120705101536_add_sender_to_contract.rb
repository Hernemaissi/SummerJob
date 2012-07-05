class AddSenderToContract < ActiveRecord::Migration
  def change
    add_column :contracts, :negotiation_sender_id, :integer
  end
end
