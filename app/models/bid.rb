class Bid < ActiveRecord::Base
  attr_accessible :amount, :message, :offer, :service_level
  
  belongs_to :rfp
  has_one :contract

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
  
  def status_to_s
    if accepted?
      "Accepted"
    elsif rejected?
      "Rejected"
    else
      "Waiting"
    end
  end
  
  def sign_contract!(service_provider_id, service_buyer_id)
    contract = self.create_contract
    contract.service_provider_id = service_provider_id
    contract.service_buyer_id = service_buyer_id
    contract.save
    contract
  end

  def can_accept?
    !self.provider.role.specialized? || self.provider.role.service_level == self.service_level
  end
  
  def validate_specialize
    if self.provider.role.specialized? && self.service_level != self.provider.role.service_level && self.sender == self.provider
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
#

