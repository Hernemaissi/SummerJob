class NetworkReport < ActiveRecord::Base
  attr_accessible :customer_revenue, :network_id, :promised_level, :realized_level, :sales, :satisfaction, :year

  belongs_to :network
end
# == Schema Information
#
# Table name: network_reports
#
#  id               :integer         not null, primary key
#  year             :integer
#  sales            :integer
#  max_launch       :integer
#  performed_launch :integer
#  customer_revenue :decimal(, )
#  satisfaction     :decimal(, )
#  network_id       :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  net_cost         :decimal(, )     default(0.0)
#

