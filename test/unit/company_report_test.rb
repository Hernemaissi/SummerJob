# == Schema Information
#
# Table name: company_reports
#
#  id                   :integer          not null, primary key
#  year                 :integer
#  base_fixed_cost      :decimal(, )
#  customer_revenue     :decimal(, )
#  contract_revenue     :decimal(, )
#  profit               :decimal(, )
#  risk_control         :decimal(, )
#  contract_cost        :decimal(, )
#  variable_cost        :decimal(, )
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  company_id           :integer
#  launch_capacity_cost :decimal(, )      default(0.0)
#  extra_cost           :decimal(, )      default(0.0)
#  simulated_report     :boolean          default(TRUE)
#  launches             :integer
#  accident_cost        :decimal(20, 2)   default(0.0)
#  break_cost           :integer          default(0)
#  capacity_cost        :decimal(, )
#  unit_cost            :decimal(, )
#  experience_cost      :decimal(, )
#  marketing_cost       :decimal(, )
#  fixed_sat_cost       :decimal(, )
#  satisfaction         :decimal(, )
#  market_data          :text
#  loan_cost            :decimal(20, 2)   default(0.0)
#  expansion_cost       :decimal(20, 2)   default(0.0)
#

require 'test_helper'

class CompanyReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
