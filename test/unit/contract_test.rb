# == Schema Information
#
# Table name: contracts
#
#  id                    :integer          not null, primary key
#  service_provider_id   :integer
#  service_buyer_id      :integer
#  bid_id                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  new_amount            :integer
#  under_negotiation     :boolean          default(FALSE)
#  negotiation_sender_id :integer
#  negotiation_type      :string(255)
#  actual_launches       :integer
#  launches_made         :integer          default(0)
#  new_duration          :integer
#  new_launches          :integer
#  decision_seen         :boolean          default(TRUE)
#  last_decision         :string(255)
#  void                  :boolean          default(FALSE)
#

require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
