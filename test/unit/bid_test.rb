# == Schema Information
#
# Table name: bids
#
#  id                 :integer          not null, primary key
#  amount             :integer
#  message            :text
#  status             :string(255)
#  rfp_id             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  offer              :string(255)
#  counter            :boolean
#  read               :boolean          default(FALSE)
#  reject_message     :text
#  agreed_duration    :integer
#  remaining_duration :integer
#  penalty            :decimal(20, 2)   default(0.0)
#  launches           :integer
#  broken             :boolean          default(FALSE)
#

require 'test_helper'

class BidTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
