class Contract < ActiveRecord::Base
  attr_accessible :new_amount, :new_service_level, :under_negotiation
  
  belongs_to :bid
  belongs_to :service_provider, class_name: "Company"
  belongs_to :service_buyer, class_name: "Company"
  belongs_to :negotiation_sender, class_name: "Company"
  
  validates :service_provider_id, presence: true
  validates :service_buyer_id, presence: true
  validates :bid_id, presence: true
  validates :new_amount, :numericality => { :greater_than => 0 }, :on => :update
  
  def update_values
    service_provider.revenue += bid.amount
    service_provider.save!
    service_buyer.fixedCost += bid.amount
    service_buyer.save!
  end

  def amount
    bid.amount
  end

  def service_level
    bid.service_level
  end

  def negotiation_receiver
    if negotiation_sender == service_provider
      service_buyer
    else
      service_provider
    end
  end
end
# == Schema Information
#
# Table name: contracts
#
#  id                   :integer         not null, primary key
#  service_provider_id  :integer
#  service_buyer_id     :integer
#  bid_id               :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  new_amount           :integer
#  new_service_level    :integer
#  under_negotiation    :boolean         default(FALSE)
#  negotation_sender_id :integer
#

