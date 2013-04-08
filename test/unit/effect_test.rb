# == Schema Information
#
# Table name: effects
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  description        :text
#  level_change       :integer
#  type_change        :integer
#  value_change       :integer
#  fluctuation_change :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class EffectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
