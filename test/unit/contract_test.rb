require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
# == Schema Information
#
# Table name: contracts
#
#  id                    :integer         not null, primary key
#  service_provider_id   :integer
#  service_buyer_id      :integer
#  bid_id                :integer
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  new_amount            :integer
#  new_service_level     :integer
#  under_negotiation     :boolean         default(FALSE)
#  negotiation_sender_id :integer
#

