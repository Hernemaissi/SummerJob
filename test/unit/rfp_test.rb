# == Schema Information
#
# Table name: rfps
#
#  id                  :integer          not null, primary key
#  sender_id           :integer
#  receiver_id         :integer
#  content             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  read                :boolean          default(FALSE)
#  contract_process_id :integer
#

require 'test_helper'

class RfpTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
