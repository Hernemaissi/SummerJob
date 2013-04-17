# == Schema Information
#
# Table name: qualityvalues
#
#  id         :integer          not null, primary key
#  value      :string(255)
#  quality_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class QualityvalueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
