# == Schema Information
#
# Table name: customer_facing_roles
#
#  id                 :integer          not null, primary key
#  sell_price         :integer
#  service_level      :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id         :integer
#  market_id          :integer
#  reputation         :integer          default(100)
#  belongs_to_network :boolean          default(FALSE)
#  product_type       :integer
#  sales_made         :integer          default(0)
#  last_satisfaction  :decimal(, )
#  risk_id            :integer
#

require 'test_helper'

class CustomerFacingRoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
