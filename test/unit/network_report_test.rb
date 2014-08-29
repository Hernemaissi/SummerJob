# == Schema Information
#
# Table name: network_reports
#
#  id                      :integer          not null, primary key
#  year                    :integer
#  sales                   :integer
#  max_launch              :integer
#  performed_launch        :integer
#  customer_revenue        :decimal(, )
#  satisfaction            :decimal(, )
#  network_id              :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  net_cost                :decimal(, )      default(0.0)
#  customer_facing_role_id :integer
#  relative_net_cost       :decimal(, )
#  simulated_report        :boolean          default(TRUE)
#  company_id              :integer
#  leader                  :string(255)
#  max_customers           :integer
#

require 'test_helper'

class NetworkReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
