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
#  id                :integer         not null, primary key
#  current_round     :integer         default(1)
#  max_rounds        :integer         default(3)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  sub_round         :integer         default(1)
#  calculating       :boolean         default(FALSE)
#  finished          :boolean         default(FALSE)
#  results_published :boolean         default(TRUE)
#  low_budget_min    :decimal(, )     default(1000.0)
#  low_budget_max    :decimal(, )     default(2000.0)
#  low_budget_cap    :integer         default(20)
#  high_budget_min   :decimal(, )     default(3000.0)
#  high_budget_max   :decimal(, )     default(5000.0)
#  high_budget_cap   :integer         default(40)
#  low_luxury_min    :decimal(, )     default(10000.0)
#  low_luxury_max    :decimal(, )     default(20000.0)
#  low_luxury_cap    :integer         default(10)
#  high_luxury_min   :decimal(, )     default(50000.0)
#  high_luxury_max   :decimal(, )     default(100000.0)
#  high_luxury_cap   :integer         default(5)
#

