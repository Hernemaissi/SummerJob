class Bid < ActiveRecord::Base
  attr_accessible :amount, :message, :offer, :service_provided
  
  belongs_to :rfp
  has_one :contract
  
  validate :validate_service_provided
  
  validates :amount, presence: true
  validates :offer, presence: true
  validates :message, presence: true
  validates :status, presence: true
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
    self.rfp.sender
  end
  
  def sender
    self.rfp.receiver
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
  
  def validate_service_provided
    if self.service_provided > self.sender.get_max_service
      errors.add(:service_provided, "Service provided cannot be over your maximum limit")
    end
  end
  
end
# == Schema Information
#
# Table name: bids
#
#  id               :integer         not null, primary key
#  amount           :integer
#  message          :string(255)
#  status           :string(255)
#  rfp_id           :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  service_provided :integer
#  offer            :string(255)
#

