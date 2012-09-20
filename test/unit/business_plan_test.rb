require 'test_helper'

class BusinessPlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
# == Schema Information
#
# Table name: business_plans
#
#  id             :integer         not null, primary key
#  public         :boolean         default(FALSE)
#  waiting        :boolean         default(FALSE)
#  verified       :boolean         default(FALSE)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  company_id     :integer
#  submit_date    :datetime
#  rejected       :boolean
#  reject_message :text
#

