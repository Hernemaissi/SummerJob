# == Schema Information
#
# Table name: service_roles
#
#  id            :integer          not null, primary key
#  service_level :integer
#  specialized   :boolean
#  service_type  :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  company_id    :integer
#  product_type  :integer
#

require 'test_helper'

class ServiceRoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
