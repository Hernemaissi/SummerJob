# == Schema Information
#
# Table name: bids
#
#  id                  :integer          not null, primary key
#  amount              :integer
#  message             :text
#  status              :string(255)
#  rfp_id              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  offer               :string(255)
#  counter             :boolean
#  read                :boolean          default(FALSE)
#  reject_message      :text
#  agreed_duration     :integer
#  remaining_duration  :integer
#  penalty             :decimal(20, 2)   default(0.0)
#  launches            :integer
#  broken              :boolean          default(FALSE)
#  marketing_amount    :integer
#  experience_amount   :integer
#  unit_amount         :integer
#  capacity_amount     :integer
#  contract_process_id :integer
#  receiver_id         :integer
#  sender_id           :integer
#  expired             :boolean          default(FALSE)
#

require 'test_helper'

class BidTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
