class CustomerFacingRole < ActiveRecord::Base
  attr_accessible :promised_service_level, :sell_price

  belongs_to :company
  belongs_to :market

  validates :promised_service_level, presence:  true
  
end
# == Schema Information
#
# Table name: customer_facing_roles
#
#  id                     :integer         not null, primary key
#  sell_price             :integer
#  promised_service_level :integer
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  company_id             :integer
#

