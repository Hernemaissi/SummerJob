require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
# == Schema Information
#
# Table name: games
#
#  id            :integer         not null, primary key
#  current_round :integer         default(1)
#  max_rounds    :integer         default(3)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  sub_round     :integer         default(1)
#  calculating   :boolean         default(FALSE)
#

