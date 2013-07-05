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
#

require 'test_helper'

class CompanyReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
