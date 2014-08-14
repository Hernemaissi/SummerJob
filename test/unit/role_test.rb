# == Schema Information
#
# Table name: roles
#
#  id                :integer          not null, primary key
#  sell_price        :integer
#  service_level     :integer
#  product_type      :integer
#  market_id         :integer
#  company_id        :integer
#  sales_made        :integer          default(0)
#  last_satisfaction :decimal(, )
#  number_of_units   :integer
#  unit_size         :integer
#  experience        :integer
#  marketing         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  update_flag       :boolean
#

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
