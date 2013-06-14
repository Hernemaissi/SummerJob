# == Schema Information
#
# Table name: contracts
#
#  id                    :integer          not null, primary key
#  service_provider_id   :integer
#  service_buyer_id      :integer
#  bid_id                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  new_amount            :integer
#  under_negotiation     :boolean          default(FALSE)
#  negotiation_sender_id :integer
#


#Contracts are formed between companies after a bid is accepted
class Contract < ActiveRecord::Base
  attr_accessible :new_amount,  :under_negotiation
  
  belongs_to :bid
  belongs_to :service_provider, class_name: "Company"
  belongs_to :service_buyer, class_name: "Company"
  belongs_to :negotiation_sender, class_name: "Company"
  
  validates :service_provider_id, presence: true
  validates :service_buyer_id, presence: true
  validates :bid_id, presence: true
  validates :new_amount, :numericality => { :greater_than => 0 }, :on => :update

  #Shortcut to check the amount of the accepted bid
  def amount
    bid.amount
  end

  #Returns the party that must respond to a re-negotiation request
  def negotiation_receiver
    if negotiation_sender == service_provider
      service_buyer
    else
      service_provider
    end
  end

def self.update_contracts
  contracts = Contract.all
  contracts.each do |c|
    if c.bid.remaining_duration
      c.bid.update_attribute(:remaining_duration, c.bid.remaining_duration - 1)
      if c.bid.remaining_duration <= 0
        c.bid.update_attribute(:status, Bid.rejected)
        c.destroy
      end
    end
  end
end
end
