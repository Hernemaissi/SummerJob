# == Schema Information
#
# Table name: companies
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  fixed_cost         :decimal(20, 2)   default(0.0)
#  variable_cost      :decimal(20, 2)   default(0.0)
#  revenue            :decimal(20, 2)   default(0.0)
#  profit             :decimal(20, 2)   default(0.0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  group_id           :integer
#  about_us           :text
#  assets             :decimal(20, 2)   default(0.0)
#  network_id         :integer
#  belongs_to_network :boolean          default(FALSE)
#  service_type       :string(255)
#  initialised        :boolean          default(FALSE)
#  for_investors      :text
#  risk_control_cost  :decimal(20, 2)   default(0.0)
#  risk_mitigation    :integer          default(0)
#  max_capacity       :integer          default(0)
#  capacity_cost      :decimal(20, 2)   default(0.0)
#  values_decided     :boolean          default(FALSE)
#  extra_costs        :decimal(20, 2)   default(0.0)
#  total_profit       :decimal(20, 2)   default(0.0)
#  launches_made      :integer          default(0)
#  update_flag        :boolean          default(FALSE)
#  accident_cost      :decimal(20, 2)   default(0.0)
#  earlier_choice     :string(255)
#  logo               :string(255)
#  image              :string(255)
#  show_read_events   :boolean          default(TRUE)
#  break_cost         :integer          default(0)
#  company_type_id    :integer
#  capital            :decimal(, )      default(0.0)
#  fixed_sat_cost     :decimal(, )
#  negative_capital   :boolean          default(FALSE)
#  expanded_markets   :text
#  ebt                :decimal(20, 2)   default(0.0)
#  market_data        :text
#  test               :boolean          default(FALSE)
#

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
