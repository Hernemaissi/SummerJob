# == Schema Information
#
# Table name: loans
#
#  id          :integer          not null, primary key
#  loan_amount :decimal(, )
#  interest    :integer
#  duration    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :integer
#  remaining   :integer
#

require 'test_helper'

class LoanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
