# == Schema Information
#
# Table name: games
#
#  id                           :integer          not null, primary key
#  current_round                :integer          default(1)
#  max_rounds                   :integer          default(3)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  sub_round                    :integer          default(1)
#  calculating                  :boolean          default(FALSE)
#  finished                     :boolean          default(FALSE)
#  results_published            :boolean          default(TRUE)
#  low_budget_min_operator      :integer          default(1000)
#  low_budget_max_operator      :integer          default(2000)
#  low_budget_cap_operator      :integer          default(20)
#  high_budget_min_operator     :integer          default(3000)
#  high_budget_max_operator     :integer          default(5000)
#  high_budget_cap_operator     :integer          default(40)
#  low_luxury_min_operator      :integer          default(10000)
#  low_luxury_max_operator      :integer          default(20000)
#  low_luxury_cap_operator      :integer          default(10)
#  high_luxury_min_operator     :integer          default(50000)
#  high_luxury_max_operator     :integer          default(100000)
#  high_luxury_cap_operator     :integer          default(5)
#  low_budget_var_max_operator  :integer          default(20000)
#  low_luxury_var_max_operator  :integer          default(30000)
#  high_budget_var_max_operator :integer          default(50000)
#  high_luxury_var_max_operator :integer          default(80000)
#  low_budget_var_min_operator  :integer          default(10000)
#  low_luxury_var_min_operator  :integer          default(15000)
#  high_budget_var_min_operator :integer          default(20000)
#  high_luxury_var_min_operator :integer          default(30000)
#  low_budget_min_customer      :integer          default(1000)
#  low_budget_max_customer      :integer          default(2000)
#  low_budget_cap_customer      :integer          default(20)
#  high_budget_min_customer     :integer          default(3000)
#  high_budget_max_customer     :integer          default(5000)
#  high_budget_cap_customer     :integer          default(40)
#  low_luxury_min_customer      :integer          default(10000)
#  low_luxury_max_customer      :integer          default(20000)
#  low_luxury_cap_customer      :integer          default(10)
#  high_luxury_min_customer     :integer          default(50000)
#  high_luxury_max_customer     :integer          default(100000)
#  high_luxury_cap_customer     :integer          default(5)
#  low_budget_var_max_customer  :integer          default(20000)
#  low_luxury_var_max_customer  :integer          default(30000)
#  high_budget_var_max_customer :integer          default(50000)
#  high_luxury_var_max_customer :integer          default(80000)
#  low_budget_var_min_customer  :integer          default(10000)
#  low_luxury_var_min_customer  :integer          default(15000)
#  high_budget_var_min_customer :integer          default(20000)
#  high_luxury_var_min_customer :integer          default(30000)
#  low_budget_min_tech          :integer          default(1000)
#  low_budget_max_tech          :integer          default(2000)
#  low_budget_cap_tech          :integer          default(20)
#  high_budget_min_tech         :integer          default(3000)
#  high_budget_max_tech         :integer          default(5000)
#  high_budget_cap_tech         :integer          default(40)
#  low_luxury_min_tech          :integer          default(10000)
#  low_luxury_max_tech          :integer          default(20000)
#  low_luxury_cap_tech          :integer          default(10)
#  high_luxury_min_tech         :integer          default(50000)
#  high_luxury_max_tech         :integer          default(100000)
#  high_luxury_cap_tech         :integer          default(5)
#  low_budget_var_max_tech      :integer          default(20000)
#  low_luxury_var_max_tech      :integer          default(30000)
#  high_budget_var_max_tech     :integer          default(50000)
#  high_luxury_var_max_tech     :integer          default(80000)
#  low_budget_var_min_tech      :integer          default(10000)
#  low_luxury_var_min_tech      :integer          default(15000)
#  high_budget_var_min_tech     :integer          default(20000)
#  high_luxury_var_min_tech     :integer          default(30000)
#  low_budget_min_supply        :integer          default(1000)
#  low_budget_max_supply        :integer          default(2000)
#  low_budget_cap_supply        :integer          default(20)
#  high_budget_min_supply       :integer          default(3000)
#  high_budget_max_supply       :integer          default(5000)
#  high_budget_cap_supply       :integer          default(40)
#  low_luxury_min_supply        :integer          default(10000)
#  low_luxury_max_supply        :integer          default(20000)
#  low_luxury_cap_supply        :integer          default(10)
#  high_luxury_min_supply       :integer          default(50000)
#  high_luxury_max_supply       :integer          default(100000)
#  high_luxury_cap_supply       :integer          default(5)
#  low_budget_var_max_supply    :integer          default(20000)
#  low_luxury_var_max_supply    :integer          default(30000)
#  high_budget_var_max_supply   :integer          default(50000)
#  high_luxury_var_max_supply   :integer          default(80000)
#  low_budget_var_min_supply    :integer          default(10000)
#  low_luxury_var_min_supply    :integer          default(15000)
#  high_budget_var_min_supply   :integer          default(20000)
#  high_luxury_var_min_supply   :integer          default(30000)
#  variable_hash                :text
#  sub_round_decided            :boolean
#  sign_up_open                 :boolean          default(TRUE)
#  bonus_hash                   :text
#  capital_hash                 :text
#  deadline                     :datetime
#

require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
