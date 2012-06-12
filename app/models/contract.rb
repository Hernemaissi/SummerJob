class Contract < ActiveRecord::Base
  attr_accessible
  
  belongs_to :bid
  belongs_to :service_provider, class_name: "Company"
  belongs_to :service_buyer, class_name: "Company"
  
  validates :service_provider_id, presence: true
  validates :service_buyer_id, presence: true
  validates :bid_id, presence: true
  
  def update_values
    service_provider.assets += bid.amount
    service_provider.save
    service_buyer.assets -= bid.amount
    service_buyer.update_value(service_provider.service_type, bid.service_provided)
    service_buyer.save
  end
end
# == Schema Information
#
# Table name: contracts
#
#  id                  :integer         not null, primary key
#  service_provider_id :integer
#  service_buyer_id    :integer
#  bid_id              :integer
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

