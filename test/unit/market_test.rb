require 'test_helper'

class MarketTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
# == Schema Information
#
# Table name: markets
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  customer_amount :integer
#  preferred_type  :integer
#  preferred_level :integer
#  base_price      :integer
#  price_buffer    :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  message         :string(255)
#  effect_id       :integer
#  lb_amount       :integer         default(0)
#  lb_sweet_price  :decimal(, )     default(0.0)
#  lb_max_price    :decimal(, )     default(0.0)
#  hb_amount       :integer         default(0)
#  hb_sweet_price  :decimal(, )     default(0.0)
#  hb_max_price    :decimal(, )     default(0.0)
#  ll_amount       :integer         default(0)
#  ll_sweet_price  :decimal(, )     default(0.0)
#  ll_max_price    :decimal(, )     default(0.0)
#  hl_amount       :integer         default(0)
#  hl_sweet_price  :decimal(, )     default(0.0)
#  hl_max_price    :decimal(, )     default(0.0)
#

