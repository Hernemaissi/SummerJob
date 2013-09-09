# == Schema Information
#
# Table name: plan_parts
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  content          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  business_plan_id :integer
#  position         :string(255)
#  outer            :boolean          default(FALSE)
#  updated          :boolean          default(TRUE)
#

require 'test_helper'

class PlanPartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
