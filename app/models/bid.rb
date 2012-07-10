class Bid < ActiveRecord::Base
  attr_accessible :amount, :message, :offer, :service_level
  
  belongs_to :rfp
  has_one :contract, :dependent => :destroy

  validate :validate_specialize
  
  
  validates :amount, presence: true
  validates :offer, presence: true
  validates :message, presence: true
  validates :status, presence: true
  validates :service_level, presence: true
  validates :rfp_id, presence: true
  
  def self.accepted
    return "ACC"
  end
  
  def self.waiting
    return "WAI"
  end
  
  def self.rejected
    return "REJ"
  end
  
  def accepted?
    self.status == Bid.accepted
  end
  
  def rejected?
    self.status == Bid.rejected
  end
  
  def waiting?
    !self.accepted? && !self.rejected?
  end
  
  def decided?
    !self.waiting?
  end
  
  def receiver
    if counter
      self.rfp.receiver
    else
      self.rfp.sender
    end
  end
  
  def sender
    if counter
      self.rfp.sender
    else
      self.rfp.receiver
    end
  end

  def provider
    if self.receiver.is_service?
      return self.receiver
    elsif self.sender.is_service?
      return self.sender
    elsif self.receiver.is_operator?
      return self.receiver
    else
      return self.sender
    end
  end

  def buyer
    if self.receiver == self.provider
      return self.sender
    else
      return self.receiver
    end
  end

  def agreement?
    self.provider.is_operator?
  end
  
  def status_to_s
    if accepted?
      "Accepted"
    elsif rejected?
      "Rejected"
    else
      "Waiting"
    end
  end
  
  def sign_contract!
    contract = self.create_contract
    contract.service_provider_id = self.provider.id
    contract.service_buyer_id = self.buyer.id
    contract.save!
    Network.create_network_if_ready(contract)
    contract
  end

  def can_accept?
   (( !self.provider.role.specialized? || self.provider.role.service_level == self.service_level) || self.agreement? ) && can_bid?
  end

  def can_bid?
    Rfp.can_send?(rfp.sender, rfp.receiver)
  end

  def unread?(company)
       (!self.read && self.receiver == company && self.waiting?) || (!self.read && self.sender == company && !self.waiting?)
  end
  
  def validate_specialize
    if self.provider.role.specialized? && self.service_level != self.provider.role.service_level && self.sender == self.provider && !self.agreement?
      errors.add(:service_level, "has to match the service providers service level if they are specialized")
    end
  end
  
end
# == Schema Information
#
# Table name: bids
#
#  id            :integer         not null, primary key
#  amount        :integer
#  message       :string(255)
#  status        :string(255)
#  rfp_id        :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  offer         :string(255)
#  counter       :boolean
#  service_level :integer
#  read          :boolean         default(FALSE)
#

