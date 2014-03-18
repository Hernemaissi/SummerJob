# == Schema Information
#
# Table name: roles
#
#  id                :integer          not null, primary key
#  sell_price        :integer
#  service_level     :integer
#  product_type      :integer
#  market_id         :integer
#  company_id        :integer
#  sales_made        :integer          default(0)
#  last_satisfaction :decimal(, )
#  number_of_units   :integer          default(0)
#  unit_size         :integer          default(0)
#  experience        :integer          default(0)
#  marketing         :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Role < ActiveRecord::Base
  attr_accessible :company_id, :experience, :last_satisfaction, :market_id, :marketing, :number_of_units,
    :product_type, :sales_made, :sell_price, :service_level, :unit_size

  belongs_to :company
  belongs_to :market
end
