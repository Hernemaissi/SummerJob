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
#

require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
