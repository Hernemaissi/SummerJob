# == Schema Information
#
# Table name: operator_roles
#
#  id            :integer          not null, primary key
#  service_level :integer
#  specialized   :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  company_id    :integer
#  capacity      :integer          default(1)
#  product_type  :integer
#

require 'test_helper'

class OperatorRoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
