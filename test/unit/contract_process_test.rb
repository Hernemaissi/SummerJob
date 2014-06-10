# == Schema Information
#
# Table name: contract_processes
#
#  id              :integer          not null, primary key
#  initiator_id    :integer
#  receiver_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  first_party_id  :integer
#  second_party_id :integer
#

require 'test_helper'

class ContractProcessTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
