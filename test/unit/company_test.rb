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
#  id           :integer         not null, primary key
#  name         :string(255)
#  fixedCost    :decimal(5, 2)   default(0.0)
#  variableCost :decimal(5, 2)   default(0.0)
#  revenue      :decimal(5, 2)   default(0.0)
#  profit       :decimal(5, 2)   default(0.0)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  group_id     :integer
#  service_type :string(255)
#  initialised  :boolean         default(FALSE)
#  about_us     :string(255)
#  assets       :decimal(5, 2)   default(0.0)
#  network_id   :integer
#

