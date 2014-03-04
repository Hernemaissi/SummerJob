# == Schema Information
#
# Table name: parameters
#
#  id              :integer          not null, primary key
#  capacity_name   :string(255)
#  experience_name :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  unit_name       :string(255)
#

require 'test_helper'

class ParametersTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
