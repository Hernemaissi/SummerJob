require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
# == Schema Information
#
# Table name: companies
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  fixed_cost         :decimal(20, 2)  default(0.0)
#  variable_cost      :decimal(20, 2)  default(0.0)
#  revenue            :decimal(20, 2)  default(0.0)
#  profit             :decimal(20, 2)  default(0.0)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  group_id           :integer
#  about_us           :text
#  assets             :decimal(20, 2)  default(0.0)
#  network_id         :integer
#  belongs_to_network :boolean         default(FALSE)
#  service_type       :string(255)
#  initialised        :boolean         default(FALSE)
#  for_investors      :text
#  risk_control_cost  :decimal(20, 2)  default(0.0)
#  risk_mitigation    :integer         default(0)
#

