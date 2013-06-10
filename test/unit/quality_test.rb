# == Schema Information
#
# Table name: qualities
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  used         :boolean          default(TRUE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  order_number :integer          default(1)
#

require 'test_helper'

class QualityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
