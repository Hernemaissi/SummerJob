require 'test_helper'

class RiskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
# == Schema Information
#
# Table name: risks
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  description     :text
#  customer_return :integer
#  penalty         :integer
#  possibility     :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  severity        :integer         default(1)
#

